//Arrange
var logger = A.Fake<ILogger<SystemUnderTest>>();
var sut = new SystemUnderTest(logger);

//Act
await sut.Delete(1);

//Assert
A.CallTo(() => logger.LogError(A<string>.Ignored, A<object[]>.Ignored))
    .MustHaveHappenedOnceExactly();