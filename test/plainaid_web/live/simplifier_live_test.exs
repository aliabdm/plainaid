defmodule PlainaidWeb.SimplifierLiveTest do
  use PlainaidWeb.ConnCase

  import Phoenix.LiveViewTest
  import Plainaid.TextFixtures

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}
  defp create_simplifier(_) do
    simplifier = simplifier_fixture()

    %{simplifier: simplifier}
  end

  describe "Index" do
    setup [:create_simplifier]

    test "lists all simplify_text", %{conn: conn, simplifier: simplifier} do
      {:ok, _index_live, html} = live(conn, ~p"/simplify_text")

      assert html =~ "Listing Simplify text"
      assert html =~ simplifier.content
    end

    test "saves new simplifier", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/simplify_text")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Simplifier")
               |> render_click()
               |> follow_redirect(conn, ~p"/simplify_text/new")

      assert render(form_live) =~ "New Simplifier"

      assert form_live
             |> form("#simplifier-form", simplifier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#simplifier-form", simplifier: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/simplify_text")

      html = render(index_live)
      assert html =~ "Simplifier created successfully"
      assert html =~ "some content"
    end

    test "updates simplifier in listing", %{conn: conn, simplifier: simplifier} do
      {:ok, index_live, _html} = live(conn, ~p"/simplify_text")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#simplify_text-#{simplifier.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/simplify_text/#{simplifier}/edit")

      assert render(form_live) =~ "Edit Simplifier"

      assert form_live
             |> form("#simplifier-form", simplifier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#simplifier-form", simplifier: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/simplify_text")

      html = render(index_live)
      assert html =~ "Simplifier updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes simplifier in listing", %{conn: conn, simplifier: simplifier} do
      {:ok, index_live, _html} = live(conn, ~p"/simplify_text")

      assert index_live |> element("#simplify_text-#{simplifier.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#simplify_text-#{simplifier.id}")
    end
  end

  describe "Show" do
    setup [:create_simplifier]

    test "displays simplifier", %{conn: conn, simplifier: simplifier} do
      {:ok, _show_live, html} = live(conn, ~p"/simplify_text/#{simplifier}")

      assert html =~ "Show Simplifier"
      assert html =~ simplifier.content
    end

    test "updates simplifier and returns to show", %{conn: conn, simplifier: simplifier} do
      {:ok, show_live, _html} = live(conn, ~p"/simplify_text/#{simplifier}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/simplify_text/#{simplifier}/edit?return_to=show")

      assert render(form_live) =~ "Edit Simplifier"

      assert form_live
             |> form("#simplifier-form", simplifier: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#simplifier-form", simplifier: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/simplify_text/#{simplifier}")

      html = render(show_live)
      assert html =~ "Simplifier updated successfully"
      assert html =~ "some updated content"
    end
  end
end
