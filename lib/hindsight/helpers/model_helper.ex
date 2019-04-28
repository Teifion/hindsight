defmodule Hindsight.Helper.ModelHelpers do
  @moduledoc false
  
  def parse_checkboxes(params, names) do
    names = Enum.map(names, fn n -> Atom.to_string(n) end)

    adjusted_params = names
    |> Enum.map(fn k -> {k, (if params[k] == "true", do: true, else: false)} end)
    |> Map.new
    
    Map.merge(params, adjusted_params)
  end
end