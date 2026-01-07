using Whisper.net;
using Whisper.net.Ggml;
using Whisper.net.Wave;
using NAudio.Wave;

Console.WriteLine("Podcast Transcription Tool");
Console.WriteLine("==========================");

// Define your speakers and their channel numbers (0-indexed)
var speakers = new Dictionary<int, string>
{
    { 0, "Mart de Graaf" },
    { 1, "Peter Kamphuis" },
    { 2, "Jan de Vries" }
};

var multiChannelWavFile = "C:\\Users\\MartdeGraaf\\Documents\\Audacity\\multichannel.wav";

if (!File.Exists(multiChannelWavFile))
{
    Console.WriteLine($"File not found: {multiChannelWavFile}");
    Console.WriteLine("Please export your tracks as a single multi-channel WAV file from Audacity:");
    Console.WriteLine("1. Select all tracks");
    Console.WriteLine("2. File > Export > Export Audio");
    Console.WriteLine("3. Save as WAV with all channels");
    return;
}

// Check and resample if necessary
var resampledFile = await EnsureCorrectSampleRate(multiChannelWavFile);

WhisperFactory? whisperFactory = null;
WhisperProcessor? processor = null;

try
{
    (whisperFactory, processor) = await GetProcessor();

    // Process the multi-channel audio file
    var allSegments = new List<TranscriptionSegment>();

    Console.WriteLine("\nProcessing multi-channel audio file...");

    using var fileStream = File.OpenRead(resampledFile);

    // Parse the WAV file to get channel information
    var waveParser = new WaveParser(fileStream);
    await waveParser.InitializeAsync();
    var channels = waveParser.Channels;
    var sampleRate = waveParser.SampleRate;
    var bitsPerSample = waveParser.BitsPerSample;
    var headerSize = waveParser.DataChunkPosition;
    var frameSize = bitsPerSample / 8 * channels;

    Console.WriteLine($"Audio info: {channels} channels, {sampleRate}Hz sample rate, {bitsPerSample} bits per sample");

    // Get averaged samples for processing
    var samples = await waveParser.GetAvgSamplesAsync(CancellationToken.None);

    // Process the audio and identify speakers by channel energy
    await foreach (var result in processor.ProcessAsync(samples))
    {
        var text = result.Text.Trim();
        if (string.IsNullOrWhiteSpace(text))
        {
            continue;
        }

        // Get the wave position for the specified time interval
        var startSample = (long)result.Start.TotalMilliseconds * sampleRate / 1000;
        var endSample = (long)result.End.TotalMilliseconds * sampleRate / 1000;

        // Calculate buffer size
        var bufferSize = (int)(endSample - startSample) * frameSize;
        var readBuffer = new byte[bufferSize];

        // Set fileStream position
        fileStream.Position = headerSize + startSample * frameSize;

        // Read the wave data for the specified time interval
        var read = await fileStream.ReadAsync(readBuffer.AsMemory());

        // Convert bytes to shorts
        var buffer = new short[read / 2];
        for (var i = 0; i < read; i += 2)
        {
            // Handle endianness manually and convert bytes to Int16
            buffer[i / 2] = BitConverter.IsLittleEndian
                ? (short)(readBuffer[i] | (readBuffer[i + 1] << 8))
                : (short)((readBuffer[i] << 8) | readBuffer[i + 1]);
        }

        // Calculate energy per channel to identify the speaker
        var energy = new double[channels];
        var maxEnergy = 0d;
        var maxEnergyChannel = 0;
        
        for (var i = 0; i < buffer.Length; i++)
        {
            var channel = i % channels;
            energy[channel] += Math.Pow(buffer[i], 2);

            if (energy[channel] > maxEnergy)
            {
                maxEnergy = energy[channel];
                maxEnergyChannel = channel;
            }
        }

        // Only add segment if the energy is significant (avoid silence)
        if (maxEnergy > 1000000) // Threshold to avoid silence
        {
            var speakerName = speakers.ContainsKey(maxEnergyChannel) 
                ? speakers[maxEnergyChannel] 
                : $"Unknown (Channel {maxEnergyChannel})";

            allSegments.Add(new TranscriptionSegment
            {
                Speaker = speakerName,
                Start = result.Start,
                End = result.End,
                Text = text,
                Channel = maxEnergyChannel,
                Energy = maxEnergy
            });

            Console.WriteLine($"[{result.Start:hh\\:mm\\:ss}] Channel {maxEnergyChannel} ({speakerName}): {text}");
        }
    }

    // Sort segments by timestamp
    Console.WriteLine("\n\n=== FULL TRANSCRIPTION (Sorted by Time) ===\n");
    var sortedSegments = allSegments.OrderBy(s => s.Start).ToList();

    foreach (var segment in sortedSegments)
    {
        var timestamp = $"[{segment.Start:hh\\:mm\\:ss}]";
        Console.WriteLine($"{timestamp} {segment.Speaker}: {segment.Text}");
    }

    // Save to markdown file
    var outputPath = Path.Combine(
        Path.GetDirectoryName(multiChannelWavFile) ?? "", 
        $"transcription_{DateTime.Now:yyyyMMdd_HHmmss}.md"
    );

    var markdownContent = new System.Text.StringBuilder();
    markdownContent.AppendLine("# Podcast Transcription");
    markdownContent.AppendLine();
    markdownContent.AppendLine($"**Date:** {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
    markdownContent.AppendLine($"**Audio File:** {Path.GetFileName(multiChannelWavFile)}");
    markdownContent.AppendLine($"**Channels:** {channels}");
    markdownContent.AppendLine();
    markdownContent.AppendLine("## Speakers");
    foreach (var speaker in speakers.Values.Distinct())
    {
        markdownContent.AppendLine($"- {speaker}");
    }

    markdownContent.AppendLine();
    markdownContent.AppendLine("---");
    markdownContent.AppendLine();
    markdownContent.AppendLine("## Transcription");
    markdownContent.AppendLine();

    foreach (var segment in sortedSegments)
    {
        var timestamp = $"{segment.Start:hh\\:mm\\:ss}";
        markdownContent.AppendLine($"**[{timestamp}] {segment.Speaker}:**  ");
        markdownContent.AppendLine($"{segment.Text}");
        markdownContent.AppendLine();
    }

    await File.WriteAllTextAsync(outputPath, markdownContent.ToString());

    Console.WriteLine($"\n\nTranscription saved to: {outputPath}");
    Console.WriteLine($"Total segments: {sortedSegments.Count}");
}
finally
{
    // Clean up Whisper resources
    processor?.Dispose();
    whisperFactory?.Dispose();

    // Clean up temporary resampled file if it was created
    if (resampledFile != multiChannelWavFile && File.Exists(resampledFile))
    {
        try
        {
            File.Delete(resampledFile);
        }
        catch
        {
            // Ignore cleanup errors
        }
    }
}

static async Task<string> EnsureCorrectSampleRate(string inputFile)
{
    using var reader = new AudioFileReader(inputFile);
    
    // Check if already at 16kHz and 16-bit
    if (reader.WaveFormat.SampleRate == 16000 && reader.WaveFormat.BitsPerSample == 16)
    {
        Console.WriteLine($"Audio file is already at 16kHz sample rate with 16-bit format.");
        return inputFile;
    }

    Console.WriteLine($"Resampling from {reader.WaveFormat.SampleRate}Hz to 16000Hz with 16-bit PCM format...");
    
    // Create a temporary file for the resampled audio
    var tempFile = Path.Combine(Path.GetTempPath(), $"resampled_{Guid.NewGuid()}.wav");
    
    // Convert to 16-bit 16kHz PCM format
    var targetFormat = new WaveFormat(16000, 16, reader.WaveFormat.Channels);
    
    using var resampler = new MediaFoundationResampler(reader, targetFormat)
    {
        ResamplerQuality = 60 // High quality resampling
    };
    
    // Write as 16-bit PCM WAV
    WaveFileWriter.CreateWaveFile16(tempFile, resampler.ToSampleProvider());
    
    Console.WriteLine($"Resampling complete. Using temporary file: {tempFile}");
    
    return tempFile;
}

static async Task<(WhisperFactory, WhisperProcessor)> GetProcessor()
{
    var modelFileName = "ggml-base.bin";
    var ggmlType = GgmlType.LargeV3Turbo;

    // Download model if it doesn't exist
    if (!File.Exists(modelFileName))
    {
        Console.WriteLine($"Downloading model {modelFileName}...");
        using var modelStream = await WhisperGgmlDownloader.Default.GetGgmlModelAsync(ggmlType);
        using var fileWriter = File.OpenWrite(modelFileName);
        await modelStream.CopyToAsync(fileWriter);
        Console.WriteLine("Model downloaded successfully.");
    }

    var whisperFactory = WhisperFactory.FromPath(modelFileName);
    
    // Get the number of CPU cores for parallel processing
    int processorCount = Environment.ProcessorCount;
    Console.WriteLine($"Using {processorCount} CPU threads for processing");
    
    var processor = whisperFactory.CreateBuilder()
      .WithLanguage("nl")
      .WithPrompt("Dit is een podcast van Mart de Graaf, Peter Kamphuis")
      .WithThreads(processorCount)
      .Build();
    
    return (whisperFactory, processor);
}

class TranscriptionSegment
{
    public string Speaker { get; set; } = "";
    public TimeSpan Start { get; set; }
    public TimeSpan End { get; set; }
    public string Text { get; set; } = "";
    public int Channel { get; set; }
    public double Energy { get; set; }
}