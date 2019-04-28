defmodule Hindsight.Core.FormQueries do
  @moduledoc false
  
  
  use HindsightWeb, :library
  
  alias Hindsight.Core.Form
  
  def get_forms() do
    from forms in Form
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
  
  def _search(query, :id, form_id) do
    from forms in query,
      where: forms.id == ^form_id
  end
  
  def _search(query, :ids, form_ids) do
    from forms in query,
      where: forms.id in ^form_ids
  end
  
  
  @spec preload(Ecto.Query.t) :: Ecto.Query.t
  def preload(query), do: query
  
  @spec preload(Ecto.Query.t, List.t | nil) :: Ecto.Query.t
  def preload(query, nil), do: query
  def preload(query, preloads) do
    query = if :template in preloads, do: _preload_template(query), else: query
    query = if :answers in preloads, do: _preload_answers(query), else: query
    
    query
  end
  
  def _preload_template(query) do
    from forms in query,
      join: templates in assoc(forms, :template),
      preload: [template: templates]
  end
  
  def _preload_answers(query) do
    from forms in query,
      left_join: answers in assoc(forms, :answers),
      preload: [answers: answers],
      left_join: answer_lists in assoc(forms, :answer_lists),
      preload: [answer_lists: answer_lists],
      left_join: answer_maps in assoc(forms, :answer_maps),
      preload: [answer_maps: answer_maps],
      left_join: answer_texts in assoc(forms, :answer_texts),
      preload: [answer_texts: answer_texts]
  end
  
  
  @spec order(Ecto.Query.t, String.t()) :: Ecto.Query.t
  def order(query, "Newest first") do
    from forms in query,
      order_by: [desc: forms.inserted_at]
  end
  
  def order(query, "Oldest first") do
    from forms in query,
      order_by: [asc: forms.inserted_at]
  end
  
  def order(query, "Reference (A-Z)") do
    from forms in query,
      order_by: [asc: forms.reference]
  end
  
  def order(query, "Reference (Z-A)") do
    from forms in query,
      order_by: [desc: forms.reference]
  end
end