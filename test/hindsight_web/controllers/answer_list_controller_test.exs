defmodule HindsightWeb.AnswerListControllerTest do
  use HindsightWeb.ConnCase

  alias Hindsight.Core

  @create_attrs %{value: []}
  @update_attrs %{value: []}
  @invalid_attrs %{value: nil}

  def fixture(:answer_list) do
    {:ok, answer_list} = Core.create_answer_list(@create_attrs)
    answer_list
  end

  describe "index" do
    test "lists all hindsight_answer_lists", %{conn: conn} do
      conn = get(conn, Routes.answer_list_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hindsight answer lists"
    end
  end

  describe "new answer_list" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.answer_list_path(conn, :new))
      assert html_response(conn, 200) =~ "New Answer list"
    end
  end

  describe "create answer_list" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.answer_list_path(conn, :create), answer_list: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.answer_list_path(conn, :show, id)

      conn = get(conn, Routes.answer_list_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Answer list"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.answer_list_path(conn, :create), answer_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Answer list"
    end
  end

  describe "edit answer_list" do
    setup [:create_answer_list]

    test "renders form for editing chosen answer_list", %{conn: conn, answer_list: answer_list} do
      conn = get(conn, Routes.answer_list_path(conn, :edit, answer_list))
      assert html_response(conn, 200) =~ "Edit Answer list"
    end
  end

  describe "update answer_list" do
    setup [:create_answer_list]

    test "redirects when data is valid", %{conn: conn, answer_list: answer_list} do
      conn = put(conn, Routes.answer_list_path(conn, :update, answer_list), answer_list: @update_attrs)
      assert redirected_to(conn) == Routes.answer_list_path(conn, :show, answer_list)

      conn = get(conn, Routes.answer_list_path(conn, :show, answer_list))
      assert html_response(conn, 200) =~ ""
    end

    test "renders errors when data is invalid", %{conn: conn, answer_list: answer_list} do
      conn = put(conn, Routes.answer_list_path(conn, :update, answer_list), answer_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Answer list"
    end
  end

  describe "delete answer_list" do
    setup [:create_answer_list]

    test "deletes chosen answer_list", %{conn: conn, answer_list: answer_list} do
      conn = delete(conn, Routes.answer_list_path(conn, :delete, answer_list))
      assert redirected_to(conn) == Routes.answer_list_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.answer_list_path(conn, :show, answer_list))
      end
    end
  end

  defp create_answer_list(_) do
    answer_list = fixture(:answer_list)
    {:ok, answer_list: answer_list}
  end
end
