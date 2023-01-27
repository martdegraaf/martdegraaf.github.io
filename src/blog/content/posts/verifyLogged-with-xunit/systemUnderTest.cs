public async Task Delete(long sequenceNumber)
{
  _logger.LogInformation("Deleting `{sequenceNumber}`.", sequenceNumber);
  try
  {
    await _client.Delete(..);
    _logger.LogInformation("Delete completed `{sequenceNumber}`.", sequenceNumber);
  }
  catch (InvalidOperationException ex)
    when (ex.Message.Equals($"The scheduled message with SequenceNumber = {sequenceNumber} is already being cancelled."))
  {
    _logger.LogError(ex, "Already cancelled {sequenceNumber}.", sequenceNumber);
  }
}