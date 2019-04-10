defmodule HindsightWeb.AnswerTextController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.AnswerText

  def index(conn, _params) do
    hindsight_answer_texts = Core.list_hindsight_answer_texts()
    render(conn, "index.html", hindsight_answer_texts: hindsight_answer_texts)
  end

  def new(conn, _params) do
    changeset = Core.change_answer_text(%AnswerText{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer_text" => answer_text_params}) do
    case Core.create_answer_text(answer_text_params) do
      {:ok, answer_text} ->
        conn
        |> put_flash(:info, "Answer text created successfully.")
        |> redirect(to: Routes.answer_text_path(conn, :show, answer_text))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer_text = Core.get_answer_text!(id)
    render(conn, "show.html", answer_text: answer_text)
  end

  def edit(conn, %{"id" => id}) do
    answer_text = Core.get_answer_text!(id)
    changeset = Core.change_answer_text(answer_text)
    render(conn, "edit.html", answer_text: answer_text, changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer_text" => answer_text_params}) do
    answer_text = Core.get_answer_text!(id)

    case Core.update_answer_text(answer_text, answer_text_params) do
      {:ok, answer_text} ->
        conn
        |> put_flash(:info, "Answer text updated successfully.")
        |> redirect(to: Routes.answer_text_path(conn, :show, answer_text))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", answer_text: answer_text, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer_text = Core.get_answer_text!(id)
    {:ok, _answer_text} = Core.delete_answer_text(answer_text)

    conn
    |> put_flash(:info, "Answer text deleted successfully.")
    |> redirect(to: Routes.answer_text_path(conn, :index))
  end
end
