defmodule Utils.Time do

  def months_ago(months \\ 1) do
    :os.system_time(:second) - 2592000 * months
  end

  def weeks_ago(weeks \\ 1) do
    :os.system_time(:second) - 604800 * weeks
  end

  def days_ago(days \\ 1) do
    :os.system_time(:second) - 86400 * days
  end

  def hours_ago(hours \\ 1) do
    :os.system_time(:second) - 3600 * hours
  end

  def minutes_ago(minutes \\ 1) do
    :os.system_time(:second) - 60 * minutes
  end
  
end
