defmodule HindsightWeb.Core.FormController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.Form

  def index(conn, _params) do
    hindsight_forms = Core.list_hindsight_forms()
    render(conn, "index.html", hindsight_forms: hindsight_forms)
  end

  def new(conn, _params) do
    changeset = Core.change_form(%Form{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"form" => form_params}) do
    case Core.create_form(form_params) do
      {:ok, form} ->
        conn
        |> put_flash(:info, "Form created successfully.")
        |> redirect(to: Routes.form_path(conn, :show, form))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    form = Core.get_form!(id)
    render(conn, "show.html", form: form)
  end

  def edit(conn, %{"id" => id}) do
    form = Core.get_form!(id)
    changeset = Core.change_form(form)
    render(conn, "edit.html", form: form, changeset: changeset)
  end

  def update(conn, %{"id" => id, "form" => form_params}) do
    form = Core.get_form!(id)

    case Core.update_form(form, form_params) do
      {:ok, form} ->
        conn
        |> put_flash(:info, "Form updated successfully.")
        |> redirect(to: Routes.form_path(conn, :show, form))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", form: form, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    form = Core.get_form!(id)
    {:ok, _form} = Core.delete_form(form)

    conn
    |> put_flash(:info, "Form deleted successfully.")
    |> redirect(to: Routes.form_path(conn, :index))
  end
end
