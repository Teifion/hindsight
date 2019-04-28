defmodule Hindsight.CoreTest do
  use Hindsight.DataCase

  alias Hindsight.Core

  describe "templates" do
    alias Hindsight.Core.Template

    @valid_attrs %{colour: "some colour", description: "some description", enabled: true, icon: "some icon", max_score: 42, name: "some name", options: %{}, use_score: true}
    @update_attrs %{colour: "some updated colour", description: "some updated description", enabled: false, icon: "some updated icon", max_score: 43, name: "some updated name", options: %{}, use_score: false}
    @invalid_attrs %{colour: nil, description: nil, enabled: nil, icon: nil, max_score: nil, name: nil, options: nil, use_score: nil}

    def template_fixture(attrs \\ %{}) do
      {:ok, template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_template()

      template
    end

    test "list_templates/0 returns all templates" do
      template = template_fixture()
      assert Core.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = template_fixture()
      assert Core.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      assert {:ok, %Template{} = template} = Core.create_template(@valid_attrs)
      assert template.colour == "some colour"
      assert template.description == "some description"
      assert template.enabled == true
      assert template.icon == "some icon"
      assert template.max_score == 42
      assert template.name == "some name"
      assert template.options == %{}
      assert template.use_score == true
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = template_fixture()
      assert {:ok, %Template{} = template} = Core.update_template(template, @update_attrs)
      assert template.colour == "some updated colour"
      assert template.description == "some updated description"
      assert template.enabled == false
      assert template.icon == "some updated icon"
      assert template.max_score == 43
      assert template.name == "some updated name"
      assert template.options == %{}
      assert template.use_score == false
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = template_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_template(template, @invalid_attrs)
      assert template == Core.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Core.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Core.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = template_fixture()
      assert %Ecto.Changeset{} = Core.change_template(template)
    end
  end

  describe "hindsight_forms" do
    alias Hindsight.Core.Form

    @valid_attrs %{completed: true, completed_at: ~N[2010-04-17 14:00:00], reference: "some reference", score: 42}
    @update_attrs %{completed: false, completed_at: ~N[2011-05-18 15:01:01], reference: "some updated reference", score: 43}
    @invalid_attrs %{completed: nil, completed_at: nil, reference: nil, score: nil}

    def form_fixture(attrs \\ %{}) do
      {:ok, template} = %{colour: "some colour", description: "some description", enabled: true, icon: "some icon", max_score: 42, name: "some name", options: %{}, use_score: true}
      |> Core.create_template()
      
      {:ok, form} =
        attrs
        |> Enum.into(Map.put(@valid_attrs, :template_id, template.id))
        |> Core.create_form()

      {form, template}
    end

    test "list_forms/0 returns all hindsight_forms" do
      {form, _template} = form_fixture()
      assert Core.list_forms() == [form]
    end

    test "get_form!/1 returns the form with given id" do
      {form, _template} = form_fixture()
      assert Core.get_form!(form.id) == form
    end

    test "create_form/1 with valid data creates a form" do
      {_form, template} = form_fixture()
      
      assert {:ok, %Form{} = form} = Core.create_form(Map.put(@valid_attrs, :template_id, template.id))
      assert form.completed == true
      assert form.completed_at == ~N[2010-04-17 14:00:00]
      assert form.reference == "some reference"
      assert form.score == 42
    end

    test "create_form/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_form(@invalid_attrs)
    end

    test "update_form/2 with valid data updates the form" do
      {form, _template} = form_fixture()
      assert {:ok, %Form{} = form} = Core.update_form(form, @update_attrs)
      assert form.completed == false
      assert form.completed_at == ~N[2011-05-18 15:01:01]
      assert form.reference == "some updated reference"
      assert form.score == 43
    end

    test "update_form/2 with invalid data returns error changeset" do
      {form, _template} = form_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_form(form, @invalid_attrs)
      assert form == Core.get_form!(form.id)
    end

    test "delete_form/1 deletes the form" do
      {form, _template} = form_fixture()
      assert {:ok, %Form{}} = Core.delete_form(form)
      assert_raise Ecto.NoResultsError, fn -> Core.get_form!(form.id) end
    end

    test "change_form/1 returns a form changeset" do
      {form, _template} = form_fixture()
      assert %Ecto.Changeset{} = Core.change_form(form)
    end
  end

  describe "hindsight_questions" do
    alias Hindsight.Core.Question

    @valid_attrs %{description: "some description", label: "some label", options: %{}, ordering: 42, question_type: "some question_type", visible: true}
    @update_attrs %{description: "some updated description", label: "some updated label", options: %{}, ordering: 43, question_type: "some updated question_type", visible: false}
    @invalid_attrs %{description: nil, label: nil, options: nil, ordering: nil, question_type: nil, visible: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_question()

      question
    end

    test "list_hindsight_questions/0 returns all hindsight_questions" do
      question = question_fixture()
      assert Core.list_hindsight_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Core.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Core.create_question(@valid_attrs)
      assert question.description == "some description"
      assert question.label == "some label"
      assert question.options == %{}
      assert question.ordering == 42
      assert question.question_type == "some question_type"
      assert question.visible == true
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Core.update_question(question, @update_attrs)
      assert question.description == "some updated description"
      assert question.label == "some updated label"
      assert question.options == %{}
      assert question.ordering == 43
      assert question.question_type == "some updated question_type"
      assert question.visible == false
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_question(question, @invalid_attrs)
      assert question == Core.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Core.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Core.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Core.change_question(question)
    end
  end

  describe "hindsight_answer_lists" do
    alias Hindsight.Core.AnswerList

    @valid_attrs %{value: [], form_id: 1, question_id: 1}
    @update_attrs %{value: [], form_id: 1, question_id: 1}
    @invalid_attrs %{value: nil}

    def answer_list_fixture(attrs \\ %{}) do
      {:ok, answer_list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_answer_list()

      answer_list
    end

    test "list_hindsight_answer_lists/0 returns all hindsight_answer_lists" do
      answer_list = answer_list_fixture()
      assert Core.list_hindsight_answer_lists() == [answer_list]
    end

    test "get_answer_list!/1 returns the answer_list with given id" do
      answer_list = answer_list_fixture()
      assert Core.get_answer_list!(answer_list.id) == answer_list
    end

    test "create_answer_list/1 with valid data creates a answer_list" do
      assert {:ok, %AnswerList{} = answer_list} = Core.create_answer_list(@valid_attrs)
      assert answer_list.value == []
    end

    test "create_answer_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_answer_list(@invalid_attrs)
    end

    test "update_answer_list/2 with valid data updates the answer_list" do
      answer_list = answer_list_fixture()
      assert {:ok, %AnswerList{} = answer_list} = Core.update_answer_list(answer_list, @update_attrs)
      assert answer_list.value == []
    end

    test "update_answer_list/2 with invalid data returns error changeset" do
      answer_list = answer_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_answer_list(answer_list, @invalid_attrs)
      assert answer_list == Core.get_answer_list!(answer_list.id)
    end

    test "delete_answer_list/1 deletes the answer_list" do
      answer_list = answer_list_fixture()
      assert {:ok, %AnswerList{}} = Core.delete_answer_list(answer_list)
      assert_raise Ecto.NoResultsError, fn -> Core.get_answer_list!(answer_list.id) end
    end

    test "change_answer_list/1 returns a answer_list changeset" do
      answer_list = answer_list_fixture()
      assert %Ecto.Changeset{} = Core.change_answer_list(answer_list)
    end
  end

  describe "hindsight_answer_maps" do
    alias Hindsight.Core.AnswerMap

    @valid_attrs %{value: %{}, form_id: 1, question_id: 1}
    @update_attrs %{value: %{}, form_id: 1, question_id: 1}
    @invalid_attrs %{value: nil}

    def answer_map_fixture(attrs \\ %{}) do
      {:ok, answer_map} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_answer_map()

      answer_map
    end

    test "list_hindsight_answer_maps/0 returns all hindsight_answer_maps" do
      answer_map = answer_map_fixture()
      assert Core.list_hindsight_answer_maps() == [answer_map]
    end

    test "get_answer_map!/1 returns the answer_map with given id" do
      answer_map = answer_map_fixture()
      assert Core.get_answer_map!(answer_map.id) == answer_map
    end

    test "create_answer_map/1 with valid data creates a answer_map" do
      assert {:ok, %AnswerMap{} = answer_map} = Core.create_answer_map(@valid_attrs)
      assert answer_map.value == %{}
    end

    test "create_answer_map/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_answer_map(@invalid_attrs)
    end

    test "update_answer_map/2 with valid data updates the answer_map" do
      answer_map = answer_map_fixture()
      assert {:ok, %AnswerMap{} = answer_map} = Core.update_answer_map(answer_map, @update_attrs)
      assert answer_map.value == %{}
    end

    test "update_answer_map/2 with invalid data returns error changeset" do
      answer_map = answer_map_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_answer_map(answer_map, @invalid_attrs)
      assert answer_map == Core.get_answer_map!(answer_map.id)
    end

    test "delete_answer_map/1 deletes the answer_map" do
      answer_map = answer_map_fixture()
      assert {:ok, %AnswerMap{}} = Core.delete_answer_map(answer_map)
      assert_raise Ecto.NoResultsError, fn -> Core.get_answer_map!(answer_map.id) end
    end

    test "change_answer_map/1 returns a answer_map changeset" do
      answer_map = answer_map_fixture()
      assert %Ecto.Changeset{} = Core.change_answer_map(answer_map)
    end
  end

  describe "hindsight_answer_texts" do
    alias Hindsight.Core.AnswerText

    @valid_attrs %{value: "some value", form_id: 1, question_id: 1}
    @update_attrs %{value: "some updated value", form_id: 1, question_id: 1}
    @invalid_attrs %{value: nil}

    def answer_text_fixture(attrs \\ %{}) do
      {:ok, answer_text} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_answer_text()

      answer_text
    end

    test "list_hindsight_answer_texts/0 returns all hindsight_answer_texts" do
      answer_text = answer_text_fixture()
      assert Core.list_hindsight_answer_texts() == [answer_text]
    end

    test "get_answer_text!/1 returns the answer_text with given id" do
      answer_text = answer_text_fixture()
      assert Core.get_answer_text!(answer_text.id) == answer_text
    end

    test "create_answer_text/1 with valid data creates a answer_text" do
      assert {:ok, %AnswerText{} = answer_text} = Core.create_answer_text(@valid_attrs)
      assert answer_text.value == "some value"
    end

    test "create_answer_text/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_answer_text(@invalid_attrs)
    end

    test "update_answer_text/2 with valid data updates the answer_text" do
      answer_text = answer_text_fixture()
      assert {:ok, %AnswerText{} = answer_text} = Core.update_answer_text(answer_text, @update_attrs)
      assert answer_text.value == "some updated value"
    end

    test "update_answer_text/2 with invalid data returns error changeset" do
      answer_text = answer_text_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_answer_text(answer_text, @invalid_attrs)
      assert answer_text == Core.get_answer_text!(answer_text.id)
    end

    test "delete_answer_text/1 deletes the answer_text" do
      answer_text = answer_text_fixture()
      assert {:ok, %AnswerText{}} = Core.delete_answer_text(answer_text)
      assert_raise Ecto.NoResultsError, fn -> Core.get_answer_text!(answer_text.id) end
    end

    test "change_answer_text/1 returns a answer_text changeset" do
      answer_text = answer_text_fixture()
      assert %Ecto.Changeset{} = Core.change_answer_text(answer_text)
    end
  end

  describe "hindsight_answers" do
    alias Hindsight.Core.Answer

    @valid_attrs %{value: "some value", form_id: 1, question_id: 1}
    @update_attrs %{value: "some updated value", form_id: 1, question_id: 1}
    @invalid_attrs %{value: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Core.create_answer()

      answer
    end

    test "list_hindsight_answers/0 returns all hindsight_answers" do
      answer = answer_fixture()
      assert Core.list_hindsight_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Core.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Core.create_answer(@valid_attrs)
      assert answer.value == "some value"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{} = answer} = Core.update_answer(answer, @update_attrs)
      assert answer.value == "some updated value"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_answer(answer, @invalid_attrs)
      assert answer == Core.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Core.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Core.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Core.change_answer(answer)
    end
  end
end
