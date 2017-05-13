# KV

## Trivial distributed (soon) key value store to explore OTP behaviors and supervision strategies.

## Currently Implemented
  1. KV.Supervisor -> Application supervisor for workers and other supervisors, :rest_for_one strategy
  2. KV.Registry -> OTP Genserver for registerying buckets, buckets are independent key value stores, if KV.Registry crashes, the application is restarted
  3. KV.Bucket.Supervisor -> Supervisor for grouping and managing KV buckets, :simple_one_for_one strategy, if KV.Bucket.Supervisor goes down, Registry stays up but supervisor and buckets are restarted
  4. KV.Bucket -> Module implementing Agent for stateful KV stores.

## Tests
```mix test```

