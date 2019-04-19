defmodule Hindsight.Helpers.TimexHelpersTest do
  use Hindsight.DataCase, async: true
  
  alias Hindsight.Helpers.TimexHelpers
  
  test "hms_or_dmy" do
    from = Timex.to_datetime({{2013, 12, 4}, {06, 20, 5}}, "Europe/London")
    today = Timex.beginning_of_day(from)

    params = [
      [Timex.shift(from, hours: -1), "Today at 05:20:05"],
      [Timex.shift(from, days: -14), "20/11/2013"],
    ]

    for [input_value, expected] <- params do
      assert TimexHelpers.hms_or_dmy(input_value, today) == expected
    end
  end
end