defmodule Hindsight.Helpers.InputHelper do
  @moduledoc """
  """
  
  use Phoenix.HTML
  
  import Hindsight.Helpers.TimexHelper
  
  # http://blog.plataformatec.com.br/2016/09/dynamic-forms-with-phoenix/
  def input_with_type(form, field, type) do
    input_with_type(form, field, type, [])
  end
  
  def input_with_type(form, field, type, opts) do
    ptype = case type do
      "string" -> :text_input
      "integer" -> :number_input
      "password" -> :password_input
      "text" -> :textarea
      "boolean" -> :checkbox
      "date" -> :date_select
      "datetime" -> :datetime_select
      "color" -> :color_input
      "colour" -> :color_input
      "select" -> :select
      _ -> :text_input
    end
    
    case ptype do
      _ -> input(form, field, opts ++ [using: ptype]) 
    end
  end
  
  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)
    
    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    input_opts = [class: "form-control"]
    
    # A bit messy but the best way I can think of doing it
    input_opts = input_opts ++ if opts[:autofocus], do: [autofocus: "autofocus"], else: []
    
    input_opts = input_opts ++ if opts[:placeholder], do: [placeholder: opts[:placeholder]], else: []
    input_opts = input_opts ++ if opts[:rows], do: [rows: opts[:rows]], else: []
    input_opts = input_opts ++ if opts[:columns], do: [columns: opts[:columns]], else: []
    
    input_opts = input_opts ++ if opts[:class], do: [class: opts[:class]], else: []
    
    input_opts = input_opts ++ if opts[:style], do: [style: opts[:style]], else: []
    
    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = apply(Phoenix.HTML.Form, type, [form, field, input_opts])
      error = HindsightWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end
  
  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "has-error"
      true -> "has-success"
    end
  end
  
  def date_picker(form, field, _opts \\ []) do
    v = input_value(form, field)
    
    existing_value = cond do
      v == nil -> ""
      v == "" -> ""
      is_map(v) -> dmy(v)
      true -> v
    end
    
    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    
    field_name = "#{form.name}[#{field}]"
    
    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = {:safe, ["<input type='text' name='", field_name, "' value='", existing_value, "' class='form-control datepicker'>"]}
      error = HindsightWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end
end