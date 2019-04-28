defmodule Hindsight.Core.FormQueries do
  use HindsightWeb, :library
  
  alias Hindsight.Core.Form
  
  def get_form(form_id) do
    from forms in Form,
      where: forms.id == ^form_id
  end
  
  def get_form_from_guid(form_guid) do
    from forms in Form,
      where: forms.public_guid == ^form_guid
  end
  
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
  
  def _search(query, :simple_search, ref) do
    ref_like = "%" <> String.replace(ref, "*", "%") <> "%"
    
    from forms in query,
      where: (
            ilike(forms.reference, ^ref_like)
        )
  end
  
  def _search(query, :template_id, template_id) do
    from forms in query,
      where: forms.template_id == ^template_id
  end
  
  def _search(query, :template_ids, template_ids) do
    from forms in query,
      where: forms.template_id in ^template_ids
  end
  
  def _search(query, :template_names, template_names) do
    from forms in query,
      where: forms.template_name in ^template_names
  end
  
  def _search(query, :author, author_id) do
    from forms in query,
      where: forms.author_id == ^author_id
  end
  
  def _search(query, :groups, groups) do
    from forms in query,
      where: (forms.group_id in ^groups) or is_nil(forms.group_id)
  end
  
  def _search(query, :group, group_id) do
    from forms in query,
      where: (forms.group_id == ^group_id) or is_nil(forms.group_id)
  end
  
  def _search(query, :feedback, user_id) do
    from forms in query,
      join: users in assoc(forms, :users),
      join: templates in assoc(forms, :template),
      where: users.id == ^user_id,
      where: templates.uses_feedback == true,
      where: forms.completed == true
  end


  def preload(query, nil), do: query
  def preload(query, preloads \\ []) do
    query = if :template in preloads, do: _preload_template(query), else: query
    query = if :answers in preloads, do: _preload_answers(query), else: query
    
    query
  end
  
  def _preload_template(query) do
    from forms in query,
      join: templates in assoc(forms, :template),
      preload: [template: templates]
  end
  
  def preload_template_with_accesses(query) do
    from forms in query,
      left_join: templates in assoc(forms, :template),
      left_join: accesses in assoc(templates, :accesses),
      left_join: user_groups in assoc(accesses, :user_group),
      preload: [template: {templates, accesses: {accesses, user_group: user_groups}}]
  end
  
  def preload_template_for_form(query) do
    from forms in query,
      left_join: templates in assoc(forms, :template),
      left_join: questions in assoc(templates, :questions),
      left_join: template_responses in assoc(templates, :template_responses),
      left_join: template_tags in assoc(templates, :template_tags),
      preload: [template: {templates, questions: questions, template_responses: template_responses, template_tags: template_tags}]
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