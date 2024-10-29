+++
title = "Cloud design patterns"
outputs = ["Reveal"]
author = "Mart de Graaf"
Private = true
[logo]
src = "/images/4dotnet_logo.png"
diag = "2%"
+++

{{% reveal/section %}}
# Cloud design patterns
## Building Resilient .NET Applications  
### Using Polly
by Mart de Graaf

{{% reveal/note %}}

's' - type 's' to enter speaker mode, which opens a separate window with a time and speaker notes
'o' - type 'o' to enter overview mode and scroll through slide thumbnails
'f' - type 'f' to go into full-screen mode

Design Patterns:
- https://learn.microsoft.com/en-us/azure/architecture/patterns/

{{% /reveal/note %}}

---

https://learn.microsoft.com/en-us/azure/architecture/patterns/

---

## Agenda

1. Introduction to Resilience in Cloud Applications
2. Polly for .NET
3. Key Polly Policies and Use Cases
4. Demo and Q&A

{{% /reveal/section %}}

---

## Resilience in Cloud Applications

- **Definition**
- **Importance**
- **Solution**

{{% reveal/note %}}

- **Definition**: Resilience is the ability of an application to withstand and recover from failures.
- **Importance**:
  - Cloud applications face network latency, server failures, and service outages.
  - Ensuring reliability and uptime is crucial for user experience.
- **Solution**: Use resilience patterns like retries, circuit breakers, and fallback policies.

{{% /reveal/note %}}

---

{{% reveal/section %}}

## Polly for .NET

**Polly** is a .NET library for handling transient faults and implementing resilience and transient-fault-handling policies.

- **Key Features**:
  - Retry
  - Circuit Breaker
  - Timeout
  - Bulkhead Isolation
  - Fallback

{{% reveal/note %}}

https://www.nuget.org/packages/polly/

{{% /reveal/note %}}

---

**Benefits**:

- Easy to implement.
- Works with synchronous and asynchronous operations.
- Lightweight and extensible.

---

## Polly Policies Overview

- **Retry**: Repeats a failed operation a defined number of times.
- **Circuit Breaker**: Temporarily stops requests when failures exceed a threshold.
- **Timeout**: Limits how long an operation can take before failing.
- **Bulkhead Isolation**: Isolates parts of an application to contain failures.
- **Fallback**: Specifies a backup action when the primary operation fails.

{{% /reveal/section %}}

---

## Key Polly Policies and Code Examples

### Retry Policy

```csharp
var retryPolicy = Policy
    .Handle<HttpRequestException>()
    .RetryAsync(3);

await retryPolicy.ExecuteAsync(() =>
    HttpClient.GetAsync("https://api.example.com")
);
```

---

### Circuit Breaker Policy

```csharp
var circuitBreakerPolicy = Policy
    .Handle<HttpRequestException>()
    .CircuitBreakerAsync(2, TimeSpan.FromMinutes(1));

await circuitBreakerPolicy.ExecuteAsync(() =>
    HttpClient.GetAsync("https://api.example.com")
);
```

---

## Advanced Circuit Breaker Policy

```csharp
CircuitBreaker = Policy
	.Handle<HttpException>()
	.AdvancedCircuitBreakerAsync(
		failureThreshold: 0.5, // 50%
		samplingDuration: TimeSpan.FromMinutes(5),
		minimumThroughput: 5,
		durationOfBreak: TimeSpan.FromMinutes(5),
		(ex, breakDelay) =>
		{
			// Log that the service is offline
		},
		() =>
		{
			// Log that the service is back online
		},
		() =>
		{
            // Log that the service is under stress
		}
	);
```

---

### Circuit Breaker Health check

A snippet in a `StartUp.cs` file:

```csharp
services.AddHealthChecks()

.AddCheck<ISomeCoolClient>("External API", (service, token) => service.CircuitState switch
{
    CircuitState.Open => HealthCheckResult.Degraded("Too many errors have occurred recently, will wait for a while and retry."),
    CircuitState.Isolated => HealthCheckResult.Degraded("Service disabled manually"),
    CircuitState.HalfOpen => HealthCheckResult.Degraded("Service was offline after errors, ready to try again."),
    CircuitState.Closed => HealthCheckResult.Healthy("Service ready"),
    _ => HealthCheckResult.Unhealthy($"Circuit breaker has an unknown state {service.CircuitState}.")
})
```

---

{{% reveal/section %}}

## Integrating Polly

- **Why Integrate Polly?**
  - Adds resilience to external calls, reducing the impact of transient errors.
  - Helps applications recover from brief outages and service interruptions.

---

- **Use Cases**:
  - Retry logic with Azure Cosmos DB, Azure Blob Storage, and other services.
  - Circuit breaking for external dependencies.
  - Timeout policies for long-running operations.
  - Fallback strategies for failed requests.


{{% /reveal/section %}}

---

## Polly best practices

- Dont handle the `System.Exception` type.
- Don't DDOS your service using the Retry policy. Use the `WaitAndRetry` policy for exponential backoff.
- Use the `CircuitBreaker` policy to prevent cascading failures.

---

## Demo Time!

1. Set up a .NET project with Polly and Azure SDK packages.
2. Implement a retry policy for an REST API.
3. Test the policy with transient errors.

---

## Resources

- **Polly Documentation**: [https://github.com/App-vNext/Polly](https://github.com/App-vNext/Polly)
- **Azure SDK for .NET Documentation**: [https://docs.microsoft.com/en-us/dotnet/azure/](https://docs.microsoft.com/en-us/dotnet/azure/)

---

## Q&A

**Questions?**

Let's dive deeper into Polly and Azure SDK best practices.

