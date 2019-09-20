defmodule ExqThroughputTest do
  use ExUnit.Case

  def benchmark(parallel) do
    Benchee.run(
      %{
        "default enqueuer" => fn _ ->
          {:ok, _} = ExqThroughput.Enqueuer.enqueue_default()
        end,
        "named enqueuer" => fn _ ->
          {:ok, _} = ExqThroughput.Enqueuer.named_enqueue()
        end,
        "poolboy enqueuer" => fn _ ->
          {:ok, _} = ExqThroughput.Enqueuer.poolboy_enqueue()
        end
      },
      warmup: 1,
      time: 4,
      parallel: parallel,
      before_scenario: fn _ ->
        Redix.command(:redix, ["DEL", "exq:queue:throughput_queue"])
      end,
      after_scenario: fn _ ->
        Redix.command(:redix, ["DEL", "exq:queue:throughput_queue"])
      end
    )
  end

  test "enqueuer throughput benchmarks 1", do: benchmark(1)
  test "enqueuer throughput benchmarks 6", do: benchmark(6)
  test "enqueuer throughput benchmarks 12", do: benchmark(12)
  test "enqueuer throughput benchmarks 24", do: benchmark(24)
  test "enqueuer throughput benchmarks 48", do: benchmark(48)
end
