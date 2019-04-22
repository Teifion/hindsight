defmodule Hindsight.Core.FormQueries do
  use HindsightWeb, :library
  
  alias Hindsight.Core.Form
  alias Hindsight.Core.QuestionLib
  
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
  
  @spec search(Ecto.Query.t, atom, String.t() | nil) :: Ecto.Query.t
  def search(query, _, ""), do: query
  def search(query, _, nil), do: query
  
  def search(query, :ids, form_ids) do
    from forms in query,
      where: forms.id in ^form_ids
  end
  
  def search(query, :simple_search, ref) do
    ref_like = "%" <> String.replace(ref, "*", "%") <> "%"
    
    from forms in query,
      where: (
            ilike(forms.reference, ^ref_like)
        )
  end
  
  def search(query, :template_id, template_id) do
    from forms in query,
      where: forms.template_id == ^template_id
  end
  
  def search(query, :template_ids, template_ids) do
    from forms in query,
      where: forms.template_id in ^template_ids
  end
  
  def search(query, :template_names, template_names) do
    from forms in query,
      where: forms.template_name in ^template_names
  end
  
  def search(query, :author, author_id) do
    from forms in query,
      where: forms.author_id == ^author_id
  end
  
  def search(query, :groups, groups) do
    from forms in query,
      where: (forms.group_id in ^groups) or is_nil(forms.group_id)
  end
  
  def search(query, :group, group_id) do
    from forms in query,
      where: (forms.group_id == ^group_id) or is_nil(forms.group_id)
  end
  
  def search(query, :feedback, user_id) do
    from forms in query,
      join: users in assoc(forms, :users),
      join: templates in assoc(forms, :template),
      where: users.id == ^user_id,
      where: templates.uses_feedback == true,
      where: forms.completed == true
  end

  def preload(query, preloads \\ []) do
    query = if :template in preloads, do: preload_template(query), else: query
    
    query
  end
  
  def preload_template(query) do
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
  
  def preload_answers(query) do
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