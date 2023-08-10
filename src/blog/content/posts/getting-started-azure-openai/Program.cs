// Note: The Azure OpenAI client library for .NET is in preview.
// Install the .NET library via NuGet: dotnet add package Azure.AI.OpenAI --version 1.0.0-beta.5 

using Azure;
using Azure.AI.OpenAI;

var dieren = new[] {
    "Penguins",
    "Giraffes",
    "Smurfen",
    // more
    };

OpenAIClient client = new OpenAIClient(
    new Uri("https://martgpt-openai.openai.azure.com/"),
    new AzureKeyCredential("HERE COMES YOUR API KEY"));

// ### If streaming is not selected
foreach (var dier in dieren)
{
    Response<ChatCompletions> responseWithoutStream = await client.GetChatCompletionsAsync(
        "MartGPT", //<= This is the deployment name
        new ChatCompletionsOptions()
        {
            Messages =
            {
            new ChatMessage(ChatRole.User, dier),
            new ChatMessage(ChatRole.User, @"Geef antwoord in JSON met categorie property van het type string met als waarde een van deze categorien:
Landdieren
Zeedieren

In welke categorie valt deze diersoort en geef een omschrijving met maximaal 5 woorden en geef ook de naam van het dier terug."),
            },
            Temperature = (float)1,
            MaxTokens = 800,
            NucleusSamplingFactor = (float)1,
            FrequencyPenalty = 0,
            PresencePenalty = 0,
        });
    ChatCompletions completions = responseWithoutStream.Value;
    foreach (var choice in completions.Choices)
    {
        Console.WriteLine(choice.Message.Content);
    }

}