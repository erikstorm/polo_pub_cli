defmodule PoloPubCli do
  alias Utils.Printer

  def start(_type, _args) do
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main(args) do
    args
    |> parse_args
    |> handle_args
  end

  def parse_args(args) do
    case OptionParser.parse(args) do
      {[price: currency_pair], _, _} -> {:price, currency_pair}
      {[watch: currency_pair], _, _} -> {:watch, currency_pair}
      {[ticker: true], _, _} -> :ticker
      {[help: true], _, _} -> :help
      _ -> :help
    end
  end

  def handle_args({:price, currency_pair}) do
    data = ProgressBar.render_spinner [
      text: "Fetching pricedata for #{currency_pair}…",
      done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done."],
      frames: :braille],
      fn ->
      Poloniex.ChartData.chartdata_all(currency_pair)
    end

    Printer.data_message({:price, data, currency_pair})
  end

  def handle_args({:watch, currency_pair}) do
    data = ProgressBar.render_spinner [
      text: "Updating pricedata for #{currency_pair}…",
      done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done."],
      frames: :braille],
      fn ->
      Poloniex.ChartData.chartdata_all(currency_pair)
    end

    Printer.data_message({:price, data, currency_pair})

    # Loop.
    :timer.sleep(15000)
    IO.ANSI.clear # Clearing the terminal does not seem to work.
    handle_args({:watch, currency_pair})
  end

  def handle_args(:ticker) do
    data = ProgressBar.render_spinner [
      text: "Fetching ticker…",
      done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done."],
      frames: :braille],
      fn ->
      Poloniex.ticker
    end
    
    Printer.data_message({:ticker, data})
  end

  def handle_args(:help) do
    Printer.help_message
  end

end
