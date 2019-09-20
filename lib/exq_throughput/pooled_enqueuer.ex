defmodule ExqThroughput.PooledEnqueuer do
  def start_link(_) do
    # Hack to make Exq happy with running
    num = :rand.uniform(100_000_000) + 100
    name = :"Elixir.Exq#{num}"
    Exq.Enqueuer.start_link(name: name)

    # We need to put the enqueuer instance into the pool
    {:ok, Process.whereis(:"#{name}.Enqueuer")}
  end
end
