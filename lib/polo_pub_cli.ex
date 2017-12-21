defmodule PoloPubCli do
  alias Utils.Printer

  # Start supervisor
  def start(_type, _args) do
    Supervisor.start_link([], strategy: :one_for_one)
  end

  # Program structure
  def main(args) do
    args
    |> parse_args
    |> handle_args
  end

  # https://hexdocs.pm/elixir/OptionParser.html
  def parse_args(args) do
    case OptionParser.parse(args) do
      {[price: currency_pair], _, _} -> {:price, currency_pair}
      {[watch: currency_pair], _, _} -> {:watch, currency_pair}
      {[ticker: true], _, _} -> :ticker
      {[help: true], _, _} -> :help
      _ -> :help
    end
  end

  # Get price of currency pair
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

  # Live watch price of currency pair
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
    IO.ANSI.clear # Does not seem to work.
    handle_args({:watch, currency_pair})
  end

  # Get ticker
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

  # Help/usage instructions
  def handle_args(:help) do
    Printer.help_message
  end

end
