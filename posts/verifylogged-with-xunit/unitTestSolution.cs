//Arrange
var logger = A.Fake<ILogger<SystemUnderTest>>();
var sut = new SystemUnderTest(logger);

//Act
await sut.Delete(1);

//Assert
logger.VerifyLogged(LogLevel.Information, "Deleting 1");
logger.VerifyLogged(LogLevel.Error, "Already cancelled 1");