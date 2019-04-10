defmodule HindsightWeb.FormControllerTest do
  use HindsightWeb.ConnCase

  alias Hindsight.Core

  @create_attrs %{completed: true, completed_at: ~N[2010-04-17 14:00:00], reference: "some reference", score: 42}
  @update_attrs %{completed: false, completed_at: ~N[2011-05-18 15:01:01], reference: "some updated reference", score: 43}
  @invalid_attrs %{completed: nil, completed_at: nil, reference: nil, score: nil}

  def fixture(:form) do
    {:ok, form} = Core.create_form(@create_attrs)
    form
  end

  describe "index" do
    test "lists all hindsight_forms", %{conn: conn} do
      conn = get(conn, Routes.form_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hindsight forms"
    end
  end

  describe "new form" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.form_path(conn, :new))
      assert html_response(conn, 200) =~ "New Form"
    end
  end

  describe "create form" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.form_path(conn, :create), form: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.form_path(conn, :show, id)

      conn = get(conn, Routes.form_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Form"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.form_path(conn, :create), form: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Form"
    end
  end

  describe "edit form" do
    setup [:create_form]

    test "renders form for editing chosen form", %{conn: conn, form: form} do
      conn = get(conn, Routes.form_path(conn, :edit, form))
      assert html_response(conn, 200) =~ "Edit Form"
    end
  end

  describe "update form" do
    setup [:create_form]

    test "redirects when data is valid", %{conn: conn, form: form} do
      conn = put(conn, Routes.form_path(conn, :update, form), form: @update_attrs)
      assert redirected_to(conn) == Routes.form_path(conn, :show, form)

      conn = get(conn, Routes.form_path(conn, :show, form))
      assert html_response(conn, 200) =~ "some updated reference"
    end

    test "renders errors when data is invalid", %{conn: conn, form: form} do
      conn = put(conn, Routes.form_path(conn, :update, form), form: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Form"
    end
  end

  describe "delete form" do
    setup [:create_form]

    test "deletes chosen form", %{conn: conn, form: form} do
      conn = delete(conn, Routes.form_path(conn, :delete, form))
      assert redirected_to(conn) == Routes.form_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.form_path(conn, :show, form))
      end
    end
  end

  defp create_form(_) do
    form = fixture(:form)
    {:ok, form: form}
  end
end
