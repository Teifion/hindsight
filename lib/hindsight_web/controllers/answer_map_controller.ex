defmodule HindsightWeb.AnswerMapController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.AnswerMap

  def index(conn, _params) do
    hindsight_answer_maps = Core.list_hindsight_answer_maps()
    render(conn, "index.html", hindsight_answer_maps: hindsight_answer_maps)
  end

  def new(conn, _params) do
    changeset = Core.change_answer_map(%AnswerMap{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"answer_map" => answer_map_params}) do
    case Core.create_answer_map(answer_map_params) do
      {:ok, answer_map} ->
        conn
        |> put_flash(:info, "Answer map created successfully.")
        |> redirect(to: Routes.answer_map_path(conn, :show, answer_map))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    answer_map = Core.get_answer_map!(id)
    render(conn, "show.html", answer_map: answer_map)
  end

  def edit(conn, %{"id" => id}) do
    answer_map = Core.get_answer_map!(id)
    changeset = Core.change_answer_map(answer_map)
    render(conn, "edit.html", answer_map: answer_map, changeset: changeset)
  end

  def update(conn, %{"id" => id, "answer_map" => answer_map_params}) do
    answer_map = Core.get_answer_map!(id)

    case Core.update_answer_map(answer_map, answer_map_params) do
      {:ok, answer_map} ->
        conn
        |> put_flash(:info, "Answer map updated successfully.")
        |> redirect(to: Routes.answer_map_path(conn, :show, answer_map))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", answer_map: answer_map, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    answer_map = Core.get_answer_map!(id)
    {:ok, _answer_map} = Core.delete_answer_map(answer_map)

    conn
    |> put_flash(:info, "Answer map deleted successfully.")
    |> redirect(to: Routes.answer_map_path(conn, :index))
  end
end
