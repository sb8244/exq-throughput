defmodule ExqThroughput.Enqueuer do
  alias ExqThroughput.Worker

  def enqueue_default() do
    Exq.enqueue(Exq.Enqueuer, "throughput_queue", Worker, [])
  end

  # A pool of enqueuer processes is maintained
  def poolboy_enqueue() do
    :poolboy.transaction(:enqueuer, fn pid ->
      Exq.enqueue(pid, "throughput_queue", Worker, [])
    end)
  end

  # A set of named enqueuer processes is used (no pooling)
  def named_enqueue() do
    num = :rand.uniform(ExqThroughput.Application.enqueuer_pool_size()) - 1
    Exq.enqueue(:"Elixir.Exq#{num}.Enqueuer", "throughput_queue", Worker, [])
  end
end
