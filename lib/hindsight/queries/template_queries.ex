defmodule Hindsight.Core.TemplateQueries do
  @moduledoc false
  
  
  use HindsightWeb, :library
  
  alias Hindsight.Core.Template

  def get_templates() do
    from templates in Template
  end
  
  @spec search(Ecto.Query.t, Map.t | nil) :: Ecto.Query.t
  def search(query, nil), do: query
  def search(query, params) do
    params
    |> Enum.reduce(query, fn ({key, value}, query_acc) ->
      _search(query_acc, key, value)
    end)
  end
  
  def _search(query, _, ""), do: query
  def _search(query, _, nil), do: query

  def _search(query, :id, template_id) do
    from templates in query,
      where: templates.id == ^template_id
  end
  
  @spec preload(Ecto.Query.t) :: Ecto.Query.t
  def preload(query), do: query
  
  @spec preload(Ecto.Query.t, List.t | nil) :: Ecto.Query.t
  def preload(query, nil), do: query
  def preload(query, preloads) do
    query = if :questions in preloads, do: _preload_questions(query), else: query
    
    query
  end
  
  def _preload_questions(query) do
    from templates in query,
      left_join: questions in assoc(templates, :questions),
      preload: [questions: questions],
      order_by: [asc: questions.ordering],
      order_by: [asc: questions.label]
  end
end