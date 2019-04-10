defmodule HindsightWeb.AnswerListController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.AnswerList

  def index(conn, _params) do
    hindsight_answer_lists = Core.list_hindsight_answer_lists()
    render(conn, "index.html", hindsight_answer_lists: hindsight_answer_lists)
  end

  def new(conn, _params) do
    changeset = Core.change_answer_list(%AnswerList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer_list" => answer_list_params}) do
    case Core.create_answer_list(answer_list_params) do
      {:ok, answer_list} ->
        conn
        |> put_flash(:info, "Answer list created successfully.")
        |> redirect(to: Routes.answer_list_path(conn, :show, answer_list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer_list = Core.get_answer_list!(id)
    render(conn, "show.html", answer_list: answer_list)
  end

  def edit(conn, %{"id" => id}) do
    answer_list = Core.get_answer_list!(id)
    changeset = Core.change_answer_list(answer_list)
    render(conn, "edit.html", answer_list: answer_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer_list" => answer_list_params}) do
    answer_list = Core.get_answer_list!(id)

    case Core.update_answer_list(answer_list, answer_list_params) do
      {:ok, answer_list} ->
        conn
        |> put_flash(:info, "Answer list updated successfully.")
        |> redirect(to: Routes.answer_list_path(conn, :show, answer_list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", answer_list: answer_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer_list = Core.get_answer_list!(id)
    {:ok, _answer_list} = Core.delete_answer_list(answer_list)

    conn
    |> put_flash(:info, "Answer list deleted successfully.")
    |> redirect(to: Routes.answer_list_path(conn, :index))
  end
end
