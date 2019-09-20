defmodule ExqThroughput.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      [
        {Redix, name: :redix},
        %{
          id: Exq,
          start: {Exq.Enqueuer, :start_link, []}
        },
        :poolboy.child_spec(:worker, poolboy_config())
      ] ++ named_enqueuer_pool(enqueuer_pool_size())

    # Exq needs manually started if jobs are actually processed
    # Exq.start_link([name: ExqProcessor, queues: ["throughput_queue"]])

    opts = [strategy: :one_for_one, name: ExqThroughput.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def enqueuer_pool_size(), do: :erlang.system_info(:schedulers_online)

  defp named_enqueuer_pool(count) do
    for i <- 0..(count - 1) do
      name = :"Elixir.Exq#{i}"

      %{
        id: name,
        start: {Exq.Enqueuer, :start_link, [[name: name]]}
      }
    end
  end

  def poolboy_config() do
    [
      {:name, {:local, :enqueuer}},
      {:worker_module, ExqThroughput.PooledEnqueuer},
      {:size, enqueuer_pool_size()}
    ]
  end
end
