defmodule Hindsight.Helpers.ComponentHelper do
  @moduledoc """
  """  
  
  # http://blog.danielberkompas.com/2017/01/17/reusable-templates-in-phoenix.html
  # 
  # Example usage:
  # <%= component "tabs" do %>
  #   <%= component "tab", name: "All Products" %>
  #   <%= component "tab", name: "Featured" %>
  # <% end %>
  
  def component(template, assigns) do
    HindsightWeb.ComponentView.render(template <> ".html", assigns)
  end
  
  def component(template, assigns, do: block) do
    HindsightWeb.ComponentView.render(template <> ".html", Keyword.merge(assigns, [do: block]))
  end
end