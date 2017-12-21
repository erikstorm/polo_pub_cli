defmodule Poloniex do

  @base_url "https://poloniex.com/public?command="

  # Returns the ticker for all markets.
  def ticker do
    url = @base_url <> "returnTicker"
    Utils.Request.http_get(url)
    |> Poison.decode!
  end

  # Returns the 24-hour volume for all markets, plus totals for primary currencies.
  def volume_24h do
    url = @base_url <> "return24hVolume"
    Utils.Request.http_get(url)
    |> Poison.decode!
  end

end
