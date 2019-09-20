defmodule ExqThroughput.Worker do
  require Logger

  def perform do
    Logger.info("doing some work")
  end
end
