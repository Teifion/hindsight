defmodule HindsightWeb.Core.TemplateController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.Template
  alias Hindsight.Core.Question

  def index(conn, _params) do
    templates = Core.list_templates()
    render(conn, "index.html", templates: templates)
  end

  def new(conn, _params) do
    changeset = Core.change_template(%Template{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"template" => template_params}) do
    template_params = template_params
    |> Map.merge(%{
      "options" => %{}
    })
    
    case Core.create_template(template_params) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template created successfully.")
        |> redirect(to: Routes.template_path(conn, :edit, template) <> "#questions")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    template = Core.get_template!(id, joins: [:questions])
    changeset = Core.change_template(template)

    conn
    |> assign(:template, template)
    |> assign(:changeset, changeset)
    |> assign(:question_types, Question.question_types(:with_presets))
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Core.get_template!(id)

    case Core.update_template(template, template_params) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template updated successfully.")
        |> redirect(to: Routes.template_path(conn, :edit, template))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", template: template, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Core.get_template!(id)
    {:ok, _template} = Core.delete_template(template)

    conn
    |> put_flash(:info, "Template deleted successfully.")
    |> redirect(to: Routes.template_path(conn, :index))
  end
end
