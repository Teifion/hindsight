defmodule HindsightWeb.AnswerTextControllerTest do
  use HindsightWeb.ConnCase

  alias Hindsight.Core

  @create_attrs %{value: "some value"}
  @update_attrs %{value: "some updated value"}
  @invalid_attrs %{value: nil}

  def fixture(:answer_text) do
    {:ok, answer_text} = Core.create_answer_text(@create_attrs)
    answer_text
  end

  describe "index" do
    test "lists all hindsight_answer_texts", %{conn: conn} do
      conn = get(conn, Routes.answer_text_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hindsight answer texts"
    end
  end

  describe "new answer_text" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.answer_text_path(conn, :new))
      assert html_response(conn, 200) =~ "New Answer text"
    end
  end

  describe "create answer_text" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.answer_text_path(conn, :create), answer_text: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.answer_text_path(conn, :show, id)

      conn = get(conn, Routes.answer_text_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Answer text"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.answer_text_path(conn, :create), answer_text: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Answer text"
    end
  end

  describe "edit answer_text" do
    setup [:create_answer_text]

    test "renders form for editing chosen answer_text", %{conn: conn, answer_text: answer_text} do
      conn = get(conn, Routes.answer_text_path(conn, :edit, answer_text))
      assert html_response(conn, 200) =~ "Edit Answer text"
    end
  end

  describe "update answer_text" do
    setup [:create_answer_text]

    test "redirects when data is valid", %{conn: conn, answer_text: answer_text} do
      conn = put(conn, Routes.answer_text_path(conn, :update, answer_text), answer_text: @update_attrs)
      assert redirected_to(conn) == Routes.answer_text_path(conn, :show, answer_text)

      conn = get(conn, Routes.answer_text_path(conn, :show, answer_text))
      assert html_response(conn, 200) =~ "some updated value"
    end

    test "renders errors when data is invalid", %{conn: conn, answer_text: answer_text} do
      conn = put(conn, Routes.answer_text_path(conn, :update, answer_text), answer_text: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Answer text"
    end
  end

  describe "delete answer_text" do
    setup [:create_answer_text]

    test "deletes chosen answer_text", %{conn: conn, answer_text: answer_text} do
      conn = delete(conn, Routes.answer_text_path(conn, :delete, answer_text))
      assert redirected_to(conn) == Routes.answer_text_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.answer_text_path(conn, :show, answer_text))
      end
    end
  end

  defp create_answer_text(_) do
    answer_text = fixture(:answer_text)
    {:ok, answer_text: answer_text}
  end
end
