defmodule Utils.Printer do

  def format_tickerdata(input) do
    input
    |> Enum.filter(fn({key, value}) -> key != "date" end)
    |> Enum.map(fn({key, value}) ->
        IO.puts "\n\t#{key}\n"
        Enum.map(value, fn({k, v}) ->
          if(k == "id" || k == "last" || k == "low24hr") do
            IO.puts "#{k}\t\t#{v}"
          else
            IO.puts "#{k}\t#{v}"
          end
        end)
    end)
  end

  def format_pricedata(input) do
    input
    |> Enum.filter(fn({key, value}) -> key != "date" end)
    |> Enum.map(fn({key, value}) ->
      if(key == "quoteVolume" || key == "weightedAverage") do
        "#{key}\t#{value}\n"
      else
        "#{key}\t\t#{value}\n"
      end
    end)
  end

  def data_message({:price, data, currency_pair}) do
    IO.write [
      "Showing pricedata for #{currency_pair}",
      "\n\n",
      "\t5 minutes\n",
      format_pricedata(data[:data_5min]),
      "\n\n",
      "\t15 minutes\n",
      format_pricedata(data[:data_15min]),
      "\n\n",
      "\t2 hours\n",
      format_pricedata(data[:data_2h]),
      "\n\n",
      "\t4 hours\n",
      format_pricedata(data[:data_4h]),
      "\n\n",
      "\tOne day\n",
      format_pricedata(data[:data_day]),
    ]
  end

  def data_message({:ticker, data}) do
    IO.write [
      "Poloniex ticker.",
      "\n\n",
    ]
    format_tickerdata(data)
  end

  def help_message() do
    IO.puts """

    Usage:

    ./polo_pub_cli [option] [CURRENCY_PAIR]

    Options:

    --price \t Gets currency pair price.
    --watch \t Gets price every 15 seconds.
    --ticker \t Print exchange ticker.
    --help  \t Show this helper message.

    Examples: \t ./polo_pub_cli --price "BTC_OMNI"
              \t ./polo_pub_cli --watch "BTC_LTC"
              \t ./polo_pub_cli --ticker

    Description:

    Simple cli app for pulling Poloniex public API
    price data.
    """
    System.halt
  end

end
