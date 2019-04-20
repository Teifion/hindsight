defmodule HindsightWeb.Core.QuestionController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.Question
  alias Hindsight.Core.QuestionLib

  def create(conn, %{"question" => question_params}) do
    preset = question_params["question_type"]
    |> String.slice(0, 8)
    == "Preset: "
    
    question_params = if preset do
      QuestionLib.create_from_preset(question_params)
    else
      Map.put(question_params, "options", %{"choices" => []})
    end
    
    question_params = Map.merge(
      question_params,
      %{
        "ordering" => QuestionLib.get_next_ordering(question_params["template_id"]) + 1
      }
    )

    case Core.create_question(question_params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: Routes.template_path(conn, :edit, question.template_id) <> "#questions")

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = cond do
          question_params["label"] == "" -> ", you need to have a label"
          true -> ""  
        end
        
        conn
        |> put_flash(:danger, "Question was not created#{errors}")
        |> redirect(to: Routes.template_path(conn, :edit, question_params["template_id"]) <> "#questions")
    end
  end

  def edit(conn, %{"id" => id}) do
    question = Core.get_question!(id)
    changeset = Core.change_question(question)
    
    conn
    |> assign(:question_types, Question.question_types())
    |> assign(:question, question)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "question" => question_params, "options" => options}) do
    question = Core.get_question!(id)

    options = options
    |> Hindsight.Helper.ModelHelpers.parse_checkboxes([:show_description, :required, :freestyle, :start_hidden])
    
    question_params = Map.put(question_params, "options", Map.merge(question.options, options))

    case Core.update_question(question, question_params) do
      {:ok, question} ->
        # TemplateLib.update_max_score(question.template_id)
        
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: Routes.template_path(conn, :edit, question.template_id) <> "#questions")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        
        |> assign(:question_types, QuestionLib.question_types())
        |> assign(:question, question)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    question = Core.get_question!(id)
    {:ok, _question} = Core.delete_question(question)

    conn
    |> put_flash(:info, "Question deleted successfully.")
    |> redirect(to: Routes.question_path(conn, :index))
  end
end
