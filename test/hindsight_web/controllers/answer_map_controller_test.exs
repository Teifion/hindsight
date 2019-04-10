defmodule HindsightWeb.AnswerMapControllerTest do
  use HindsightWeb.ConnCase

  alias Hindsight.Core

  @create_attrs %{value: %{}}
  @update_attrs %{value: %{}}
  @invalid_attrs %{value: nil}

  def fixture(:answer_map) do
    {:ok, answer_map} = Core.create_answer_map(@create_attrs)
    answer_map
  end

  describe "index" do
    test "lists all hindsight_answer_maps", %{conn: conn} do
      conn = get(conn, Routes.answer_map_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hindsight answer maps"
    end
  end

  describe "new answer_map" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.answer_map_path(conn, :new))
      assert html_response(conn, 200) =~ "New Answer map"
    end
  end

  describe "create answer_map" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.answer_map_path(conn, :create), answer_map: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.answer_map_path(conn, :show, id)

      conn = get(conn, Routes.answer_map_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Answer map"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.answer_map_path(conn, :create), answer_map: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Answer map"
    end
  end

  describe "edit answer_map" do
    setup [:create_answer_map]

    test "renders form for editing chosen answer_map", %{conn: conn, answer_map: answer_map} do
      conn = get(conn, Routes.answer_map_path(conn, :edit, answer_map))
      assert html_response(conn, 200) =~ "Edit Answer map"
    end
  end

  describe "update answer_map" do
    setup [:create_answer_map]

    test "redirects when data is valid", %{conn: conn, answer_map: answer_map} do
      conn = put(conn, Routes.answer_map_path(conn, :update, answer_map), answer_map: @update_attrs)
      assert redirected_to(conn) == Routes.answer_map_path(conn, :show, answer_map)

      conn = get(conn, Routes.answer_map_path(conn, :show, answer_map))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, answer_map: answer_map} do
      conn = put(conn, Routes.answer_map_path(conn, :update, answer_map), answer_map: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Answer map"
    end
  end

  describe "delete answer_map" do
    setup [:create_answer_map]

    test "deletes chosen answer_map", %{conn: conn, answer_map: answer_map} do
      conn = delete(conn, Routes.answer_map_path(conn, :delete, answer_map))
      assert redirected_to(conn) == Routes.answer_map_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.answer_map_path(conn, :show, answer_map))
      end
    end
  end

  defp create_answer_map(_) do
    answer_map = fixture(:answer_map)
    {:ok, answer_map: answer_map}
  end
end
