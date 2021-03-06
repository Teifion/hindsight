defmodule HindsightWeb.Core.FormController do
  use HindsightWeb, :controller

  alias Hindsight.Core
  alias Hindsight.Core.Form
  alias Hindsight.Core.FormLib
  alias Hindsight.Core.AnswerLib
  import Hindsight.Helpers.TimexHelper, only: [parse_ymd_hms: 1]

  def index(conn, _params) do
    hindsight_forms = Core.list_forms(joins: [:template])
    render(conn, "index.html", hindsight_forms: hindsight_forms)
  end
  
  def new(conn, %{"select" => %{"template" => template_id}}) do
    template = Core.get_template!(template_id, joins: [:questions])
    changeset = Core.change_form(%Form{})
    
    conn
    |> assign(:template, template)
    |> assign(:changeset, changeset)
    |> assign(:questions, template.questions)
    |> assign(:errors, %{})
    |> assign(:answers, %{})
    |> render("new.html")
  end
 
  def new(conn, _params) do
    templates = Core.list_templates()
    
    cond do
      Enum.empty?(templates) == 0 ->
        conn
        |> put_flash(:info, "You don't have any templates, you need to create one before you can fill in a form.")
        |> redirect(to: Routes.template_path(conn, :new))
      
      Enum.count(templates) == 1 ->
        conn
        |> redirect(to: Routes.form_path(conn, :new, %{select: %{template: hd(templates).id}}))
        
      true ->
        conn
        |> assign(:templates, templates)
        |> render("select.html")
    end
  end

  def create(conn, %{"form" => form_params}) do
    template = Core.get_template!(form_params["template_id"], joins: [:questions])
    
    errors = template.questions
    |> AnswerLib.check_for_errors(form_params)
    |> Map.new
    
    public_guid = if template.options["public_guid"] == "always" do
      FormLib.create_guid()
    else
      nil
    end

    form_params = Map.merge(form_params, %{
      "template_name" => template.name,
      "score" => FormLib.score(template, form_params),
      "completed" => form_params["completed"] == "true",
      "initial_generation_at" => parse_ymd_hms(form_params["creation_time"]),
      "completion_generation_at" => (if form_params["completed"] == "true", do: parse_ymd_hms(form_params["creation_time"])),
      "public_guid" => public_guid,
    })
    
    form_changeset = Form.changeset(%Form{}, form_params)
    
    if errors != %{} or form_changeset.valid? == false do
      answers = %{}
      |> AnswerLib.merge_answers(template.questions, form_params)
      
      conn
      |> assign(:answers, answers)
      |> assign(:errors, errors)
      |> assign(:template, template)
      |> assign(:changeset, form_changeset)
      |> assign(:creation_time, parse_ymd_hms(form_params["creation_time"]))
      |> put_flash(:danger, "Form not created, there are one or more errors.")
      |> render("new.html")
      
    else
      FormLib.insert_form_answers(form_changeset, form_params, template)
      
      case Core.create_form(form_params) do
        {:ok, form} ->
          conn
          |> put_flash(:info, "Form created successfully.")
          |> redirect(to: Routes.form_path(conn, :show, form))

        {:error, %Ecto.Changeset{} = _changeset} ->
          raise "Unexpected error saving form"
      end
    end
  end

  def show(conn, %{"id" => id}) do
    form = Core.get_form!(id, joins: [:answers])
    template = Core.get_template!(id, joins: [:questions])
    
    conn
    |> assign(:form, form)
    |> assign(:template, template)
    |> assign(:answers, AnswerLib.answer_lookup(form))
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    form = Core.get_form!(id, joins: [:answers])
    template = Core.get_template!(id, joins: [:questions])
    
    changeset = Core.change_form(form)
    
    conn
    |> assign(:form, form)
    |> assign(:template, template)
    |> assign(:answers, AnswerLib.answer_lookup(form))
    |> assign(:changeset, changeset)
    |> assign(:errors, %{})
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "form" => form_params}) do
    form = Core.get_form!(id, joins: [:answers])
    
    template = Core.get_template!(id, joins: [:questions])
    
    errors = template.questions
    |> AnswerLib.check_for_errors(form_params)
    |> Map.new
    
    if errors != %{} do
      changeset = Core.change_form(form)
      
      answers = form
      |> AnswerLib.answer_lookup
      |> AnswerLib.merge_answers(template.questions, form_params)
      
      conn
      |> assign(:form, form)
      |> assign(:errors, errors)
      |> assign(:template, template)
      |> assign(:answers, answers)
      |> assign(:changeset, changeset)
      |> render("edit.html")
    
    else
      form_changeset = Form.update_changeset(form, Map.merge(form_params,
        %{
          "score" => FormLib.score(template, form_params),
        }
      ))
      
      FormLib.update_form_answers(form_changeset, form_params, template)
      
      conn
      |> put_flash(:success, "Form updated successfully.")
      |> redirect(to: Routes.form_path(conn, :show, form.id))
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
