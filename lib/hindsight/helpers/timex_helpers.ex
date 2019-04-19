defmodule Hindsight.Helpers.TimexHelpers do
  def convert(timestamp, tz \\ Timex.Timezone.Local.lookup()) do
    new_timestamp = timestamp |> Timex.Timezone.convert(tz)
    
    case new_timestamp do
      %Timex.AmbiguousDateTime{} -> timestamp
      _ -> new_timestamp
    end
  end
  
  @spec hms_or_dmy(DateTime.t) :: String.t()
  def hms_or_dmy(nil), do: ""
  def hms_or_dmy(the_time), do: hms_or_dmy(the_time, Timex.today())
  
  def hms_or_dmy(the_time, today) do
    the_time = the_time |> convert
    
    case Timex.compare(the_time, today) do
      # The time > Today, thus it is today
      1 ->
        Timex.format!(the_time, "Today at {h24}:{m}:{s}")

      # The time <= Today, so we show the date
      0 -> 
        Timex.format!(the_time, "{0D}/{0M}/{YYYY}")

      # The time <= Today, so we show the date
      -1 ->
        Timex.format!(the_time, "{0D}/{0M}/{YYYY}")
    end
  end
  
  def hms_dmy(nil), do: ""
  def hms_dmy(the_time) do
    Timex.format!(the_time |> convert, "{h24}:{m}:{s} {0D}/{0M}/{YYYY}")
  end
  
  def hms(nil), do: ""
  def hms(the_time) do
    Timex.format!(the_time |> convert, "{h24}:{m}:{s}")
  end
  
  def hm_day(nil), do: ""
  def hm_dmy(the_time) do
    Timex.format!(the_time |> convert, "{h24}:{m} {0D}/{0M}/{YYYY}")
  end
  
  def clock24(nil), do: ""
  def clock24(the_time) do
    Timex.format!(the_time |> convert, "{h24}{m}")
  end
  
  def for_html_input(nil), do: ""
  def for_html_input(the_time) do
    Timex.format!(the_time |> convert, "{YYYY}-{0M}-{0D}T{h24}:{m}")
  end
  
  def ymd_hms(nil), do: ""
  def ymd_hms(the_time) do
    Timex.format!(the_time |> convert, "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
  end
  
  def dmy(nil), do: ""
  def dmy(the_time) do
    if Map.has_key?(the_time, "day") do
      Timex.format!(
        (for {key, val} <- the_time, into: %{}, do: {String.to_atom(key), val}),
        "{0D}/{0M}/{YYYY}"
      )
    else
      Timex.format!(the_time, "{0D}/{0M}/{YYYY}")
    end
  end
  
  def ymd(nil), do: nil
  def ymd(the_time) do
    Timex.format!(the_time, "{YYYY}-{0M}-{0D}")
  end
  
  def dmy_text(nil), do: nil
  def dmy_text(the_time) do
    suffix = Timex.format!(the_time, "{D}")
    |> String.to_integer
    |> suffix
    
    Timex.format!(the_time, "{D}#{suffix} {Mfull} {YYYY}")
  end
  
  defp suffix(1), do: "st"
  defp suffix(21), do: "st"
  defp suffix(31), do: "st"
  defp suffix(2), do: "nd"
  defp suffix(22), do: "nd"
  defp suffix(32), do: "nd"
  defp suffix(3), do: "nd"
  defp suffix(23), do: "nd"
  defp suffix(33), do: "rd"
  defp suffix(_), do: "th"
  
  
  def timex_url(the_time) do
    the_time = the_time |> convert
    
    Timex.format!(the_time, "{ISO:Extended:Z}")
  end
  
  
  def parse_dmy(nil), do: nil
  def parse_dmy(""), do: nil
  def parse_dmy(s) do
    Timex.parse!(s, "{0D}/{0M}/{YYYY}")
  end
  
  def parse_ymd(nil), do: nil
  def parse_ymd(""), do: nil
  def parse_ymd(s) do
    Timex.parse!(s, "{YYYY}-{M}-{D}")
  end
  
  def parse_ymd_hms(nil), do: nil
  def parse_ymd_hms(""), do: nil
  def parse_ymd_hms(s) do
    Timex.parse!(s, "{YYYY}-{M}-{D} {h24}:{m}:{s}")
  end
  
  def from_revision(s) when is_map(s), do: s
  def from_revision(s) do
    Timex.parse!(s, "{ISO:Extended:Z}")
  end
  
  def time_until(nil), do: nil
  def time_until(the_time), do: time_until(the_time, false)
  
  def time_until(nil, _), do: nil
  def time_until(the_time, style) do
    now = Timex.now()
    
    the_duration = Timex.diff(now, the_time, :duration)
    is_past = Timex.compare(now, the_time) == 1
    days = Timex.Duration.to_days the_duration
    
    # We need to do this as we need days rounded off in the correct
    # direction to get the number of hours left
    hours = if is_past do
      Timex.Duration.to_hours(the_duration) - (Float.floor(days) * 24)
    else
      Timex.Duration.to_hours(the_duration) - (Float.ceil(days) * 24)
    end
    
    duration_str = cond do
      round(days) > 1 -> "#{round(days)} days"
      round(days) < -1 -> "#{round(0-days)} days"
      
      round(hours) > 1 -> "#{round(hours)} hours"
      round(hours) < -1 -> "#{round(0-hours)} hours"
      
      true -> Timex.format_duration(the_duration, :humanized)
    end
    
    styling = if style and is_past do
      "text-danger"
    end
    
    "<span class='#{styling}'>#{duration_str}#{if is_past, do: ' ago (Overdue)'}</span>"
  end
  
  # Singular means you want that as a unit
  def render_segment("Day", d), do: Timex.format!(d, "{WDshort} {D}/{M}")
  def render_segment("Week", d), do: Timex.format!(d, "{D}/{M}")
  def render_segment("Month", d), do: Timex.format!(d, "{Mshort} {YYYY}")
  def render_segment("Quarter", d), do: Timex.format!(d, "{Mfull} {YYYY}")
  def render_segment("Year", d), do: Timex.format!(d, "{YYYY}")
  def render_segment("All time", _), do: ""
  
  # Ly suffix means you want to look at the units of it
  def render_segment("Weekly", d), do: Timex.format!(d, "{0D}/{0M}")
  def render_segment("Monthly", d), do: Timex.format!(d, "{Mshort} {YYYY}")
  def render_segment("Yearly", d), do: Timex.format!(d, "{YYYY}")
  
  # Catchall
  def render_segment(_, v), do: v
  
  
  # Converts the date for a segment part into the column identifier used
  def convert_to_segment_part("Weekly", d), do: Timex.format!(d, "{WDshort}")
  def convert_to_segment_part("Monthly", d), do: Timex.format!(d, "{D}")
  def convert_to_segment_part("Yearly", d), do: Timex.format!(d, "{Mshort}")
  
end