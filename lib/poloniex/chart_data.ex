defmodule Poloniex.ChartData do

  @chart_url "https://poloniex.com/public?command=returnChartData&currencyPair="

  # Returns candlestick chart data.
  # 300 = 5min, 900 = 15min, 1800 = 30min, 7200 = 2hours, 14400 = 4hours, 86400 = 24h
  # Valid "period" values are 300, 900, 1800, 7200, 14400, and 86400 (default)
  def chartdata(currency_pair, period, ts_start, ts_end) do
    url = @chart_url <> currency_pair <> "&start=" <> ts_start <> "&end=" <> ts_end <> "&period=" <> period
    Utils.Request.http_get(url)
  end

  # Timestamp interval day
  def chartdata_days(currency_pair, period \\ 86400, offset \\ 1) do
    Enum.join([@chart_url, currency_pair,
    "&start=", Utils.Time.days_ago(offset),
    "&end=", :os.system_time(:second),
    "&period=", period])
  end

  # Timestamp interval hour
  def chartdata_hour(currency_pair, period \\ 3600, offset \\ 1) do
    Enum.join([@chart_url, currency_pair,
    "&start=", Utils.Time.hours_ago(offset),
    "&end=", :os.system_time(:second),
    "&period=", period])
  end

  # Timestamp interval minute, default 5min period, 10min offset
  def chartdata_minute(currency_pair, period \\ 300, offset \\ 10) do
    Enum.join([@chart_url, currency_pair,
    "&start=", Utils.Time.minutes_ago(offset),
    "&end=", :os.system_time(:second),
    "&period=", period])
  end

  # Merge all to one map
  # todo: refractor this
  def chartdata_all(currency_pair) do
    c_data = get_volumes(currency_pair)

    # 5min
    map_5min = List.last(c_data)

    # 15min
    map_15min = Enum.take(c_data, -3)
    |> Enum.reduce(&Map.merge(&1, &2, fn _k, v1, v2 ->
          v1 + v2
        end))
        |> map_avg(3)

    # 30min
    map_30min = Enum.take(c_data, -6)
    |> Enum.reduce(&Map.merge(&1, &2, fn _k, v1, v2 ->
          v1 + v2
        end))
        |> map_avg(6)

    # 2h
    map_2h = Enum.take(c_data, -24)
    |> Enum.reduce(&Map.merge(&1, &2, fn _k, v1, v2 ->
          v1 + v2
        end))
        |> map_avg(24)

    # 4h
    map_4h = Enum.take(c_data, -48)
    |> Enum.reduce(&Map.merge(&1, &2, fn _k, v1, v2 ->
          v1 + v2
        end))
        |> map_avg(48)

    # day
    map_day = Enum.take(c_data, -144)
    |> Enum.reduce(&Map.merge(&1, &2, fn _k, v1, v2 ->
          v1 + v2
        end))
        |> map_avg(144)

    Map.merge(%{data_5min: map_5min}, %{data_15min: map_15min})
    |> Map.merge(%{data_30min: map_30min})
    |> Map.merge(%{data_30min: map_30min})
    |> Map.merge(%{data_2h: map_2h})
    |> Map.merge(%{data_4h: map_4h})
    |> Map.merge(%{data_day: map_day})

  end

  # Calculates the avg values of the map
  defp map_avg(coin_map, avg) do
    new_map = for {key, value} <- coin_map, into: %{}  do
      {key, value / avg}
    end
  end

  defp get_volumes(currency_pair) do
    # Full data with 1 day with 5min candles
    chartdata_days(currency_pair, 300, 1)
    |> Utils.Request.http_get
    |> Poison.decode!
  end

end
