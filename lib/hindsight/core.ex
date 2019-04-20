defmodule Hindsight.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias Hindsight.Repo

  alias Hindsight.Core.Template

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    Repo.all(Template)
  end
  
  def get_template_joins!(id) do
    _template_query()
    |> _template_preload(:questions)
    |> _search(:id, id)
    |> Repo.one!
  end
  
  def _search(query, :id, id) do
    from templates in query,
      where: templates.id == ^id
  end
  
  def _template_query() do
    from templates in Template
  end
  
  def _template_preload(query, :questions) do
    from templates in query,
      left_join: questions in assoc(templates, :questions),
      preload: [questions: questions],
      order_by: [asc: questions.ordering],
      order_by: [asc: questions.label]
  end

  @doc """
  Gets a single template.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(123)
      %Template{}

      iex> get_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(id), do: Repo.get!(Template, id)

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{source: %Template{}}

  """
  def change_template(%Template{} = template) do
    Template.changeset(template, %{})
  end

  alias Hindsight.Core.Form

  @doc """
  Returns the list of hindsight_forms.

  ## Examples

      iex> list_hindsight_forms()
      [%Form{}, ...]

  """
  def list_hindsight_forms do
    Repo.all(Form)
  end

  @doc """
  Gets a single form.

  Raises `Ecto.NoResultsError` if the Form does not exist.

  ## Examples

      iex> get_form!(123)
      %Form{}

      iex> get_form!(456)
      ** (Ecto.NoResultsError)

  """
  def get_form!(id), do: Repo.get!(Form, id)

  @doc """
  Creates a form.

  ## Examples

      iex> create_form(%{field: value})
      {:ok, %Form{}}

      iex> create_form(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_form(attrs \\ %{}) do
    %Form{}
    |> Form.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a form.

  ## Examples

      iex> update_form(form, %{field: new_value})
      {:ok, %Form{}}

      iex> update_form(form, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_form(%Form{} = form, attrs) do
    form
    |> Form.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Form.

  ## Examples

      iex> delete_form(form)
      {:ok, %Form{}}

      iex> delete_form(form)
      {:error, %Ecto.Changeset{}}

  """
  def delete_form(%Form{} = form) do
    Repo.delete(form)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking form changes.

  ## Examples

      iex> change_form(form)
      %Ecto.Changeset{source: %Form{}}

  """
  def change_form(%Form{} = form) do
    Form.changeset(form, %{})
  end

  alias Hindsight.Core.Question

  @doc """
  Returns the list of hindsight_questions.

  ## Examples

      iex> list_hindsight_questions()
      [%Question{}, ...]

  """
  def list_hindsight_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  alias Hindsight.Core.Answer

  @doc """
  Returns the list of hindsight_answers.

  ## Examples

      iex> list_hindsight_answers()
      [%Answer{}, ...]

  """
  def list_hindsight_answers do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{source: %Answer{}}

  """
  def change_answer(%Answer{} = answer) do
    Answer.changeset(answer, %{})
  end

  alias Hindsight.Core.AnswerList

  @doc """
  Returns the list of hindsight_answer_lists.

  ## Examples

      iex> list_hindsight_answer_lists()
      [%AnswerList{}, ...]

  """
  def list_hindsight_answer_lists do
    Repo.all(AnswerList)
  end

  @doc """
  Gets a single answer_list.

  Raises `Ecto.NoResultsError` if the Answer list does not exist.

  ## Examples

      iex> get_answer_list!(123)
      %AnswerList{}

      iex> get_answer_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer_list!(id), do: Repo.get!(AnswerList, id)

  @doc """
  Creates a answer_list.

  ## Examples

      iex> create_answer_list(%{field: value})
      {:ok, %AnswerList{}}

      iex> create_answer_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer_list(attrs \\ %{}) do
    %AnswerList{}
    |> AnswerList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer_list.

  ## Examples

      iex> update_answer_list(answer_list, %{field: new_value})
      {:ok, %AnswerList{}}

      iex> update_answer_list(answer_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer_list(%AnswerList{} = answer_list, attrs) do
    answer_list
    |> AnswerList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AnswerList.

  ## Examples

      iex> delete_answer_list(answer_list)
      {:ok, %AnswerList{}}

      iex> delete_answer_list(answer_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer_list(%AnswerList{} = answer_list) do
    Repo.delete(answer_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer_list changes.

  ## Examples

      iex> change_answer_list(answer_list)
      %Ecto.Changeset{source: %AnswerList{}}

  """
  def change_answer_list(%AnswerList{} = answer_list) do
    AnswerList.changeset(answer_list, %{})
  end

  alias Hindsight.Core.AnswerMap

  @doc """
  Returns the list of hindsight_answer_maps.

  ## Examples

      iex> list_hindsight_answer_maps()
      [%AnswerMap{}, ...]

  """
  def list_hindsight_answer_maps do
    Repo.all(AnswerMap)
  end

  @doc """
  Gets a single answer_map.

  Raises `Ecto.NoResultsError` if the Answer map does not exist.

  ## Examples

      iex> get_answer_map!(123)
      %AnswerMap{}

      iex> get_answer_map!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer_map!(id), do: Repo.get!(AnswerMap, id)

  @doc """
  Creates a answer_map.

  ## Examples

      iex> create_answer_map(%{field: value})
      {:ok, %AnswerMap{}}

      iex> create_answer_map(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer_map(attrs \\ %{}) do
    %AnswerMap{}
    |> AnswerMap.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer_map.

  ## Examples

      iex> update_answer_map(answer_map, %{field: new_value})
      {:ok, %AnswerMap{}}

      iex> update_answer_map(answer_map, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer_map(%AnswerMap{} = answer_map, attrs) do
    answer_map
    |> AnswerMap.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AnswerMap.

  ## Examples

      iex> delete_answer_map(answer_map)
      {:ok, %AnswerMap{}}

      iex> delete_answer_map(answer_map)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer_map(%AnswerMap{} = answer_map) do
    Repo.delete(answer_map)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer_map changes.

  ## Examples

      iex> change_answer_map(answer_map)
      %Ecto.Changeset{source: %AnswerMap{}}

  """
  def change_answer_map(%AnswerMap{} = answer_map) do
    AnswerMap.changeset(answer_map, %{})
  end

  alias Hindsight.Core.AnswerText

  @doc """
  Returns the list of hindsight_answer_texts.

  ## Examples

      iex> list_hindsight_answer_texts()
      [%AnswerText{}, ...]

  """
  def list_hindsight_answer_texts do
    Repo.all(AnswerText)
  end

  @doc """
  Gets a single answer_text.

  Raises `Ecto.NoResultsError` if the Answer text does not exist.

  ## Examples

      iex> get_answer_text!(123)
      %AnswerText{}

      iex> get_answer_text!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer_text!(id), do: Repo.get!(AnswerText, id)

  @doc """
  Creates a answer_text.

  ## Examples

      iex> create_answer_text(%{field: value})
      {:ok, %AnswerText{}}

      iex> create_answer_text(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer_text(attrs \\ %{}) do
    %AnswerText{}
    |> AnswerText.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer_text.

  ## Examples

      iex> update_answer_text(answer_text, %{field: new_value})
      {:ok, %AnswerText{}}

      iex> update_answer_text(answer_text, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer_text(%AnswerText{} = answer_text, attrs) do
    answer_text
    |> AnswerText.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AnswerText.

  ## Examples

      iex> delete_answer_text(answer_text)
      {:ok, %AnswerText{}}

      iex> delete_answer_text(answer_text)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer_text(%AnswerText{} = answer_text) do
    Repo.delete(answer_text)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer_text changes.

  ## Examples

      iex> change_answer_text(answer_text)
      %Ecto.Changeset{source: %AnswerText{}}

  """
  def change_answer_text(%AnswerText{} = answer_text) do
    AnswerText.changeset(answer_text, %{})
  end
end
