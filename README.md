# KV

## Trivial distributed (soon) key value store to explore OTP behaviors and supervision strategies.

## Projects List

  1. KV: Application / project level implementation
  2. JOTP: OTP reimplementations from base elixir/erlang

## Currently Implemented
  1. KV.Supervisor -> Application supervisor for workers and other supervisors, :rest_for_one strategy
  2. KV.Registry -> OTP Genserver for registerying buckets, buckets are independent key value stores, if KV.Registry crashes, the application is restarted
  3. KV.Bucket.Supervisor -> Supervisor for grouping and managing KV buckets, :simple_one_for_one strategy, if KV.Bucket.Supervisor goes down, Registry stays up but supervisor and buckets are restarted
  4. KV.Bucket -> Module implementing Agent for stateful KV stores.

## Want To
  1. JOTP.GenServer: GenServer implementation from scratch
  2. JOTP.Supervisor: Supervisor implementation from GenServer
  3. Stateful backup for supervisor replacement
  4. Comp heavy algorithm run in Pony via erlang ports

## Static Analysis

```mix dialyzer```

## Tests

```mix test```

