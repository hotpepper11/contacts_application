defmodule ContactsApplicationWeb.ContactLiveTest do
  use ContactsApplicationWeb.ConnCase

  import Phoenix.LiveViewTest
  import ContactsApplication.ContactsFixtures

  @create_attrs %{name: "some name", phone: "some phone", email: "some email", notes: "some notes"}
  @update_attrs %{name: "some updated name", phone: "some updated phone", email: "some updated email", notes: "some updated notes"}
  @invalid_attrs %{name: nil, phone: nil, email: nil, notes: nil}
  defp create_contact(_) do
    contact = contact_fixture()

    %{contact: contact}
  end

  describe "Index" do
    setup [:create_contact]

    test "lists all contacts", %{conn: conn, contact: contact} do
      {:ok, _index_live, html} = live(conn, ~p"/contacts")

      assert html =~ "Listing Contacts"
      assert html =~ contact.name
    end

    test "saves new contact", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Contact")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/new")

      assert render(form_live) =~ "New Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#contact-form", contact: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact created successfully"
      assert html =~ "some name"
    end

    test "updates contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#contacts-#{contact.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/#{contact}/edit")

      assert render(form_live) =~ "Edit Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#contact-form", contact: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts")

      html = render(index_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, ~p"/contacts")

      assert index_live |> element("#contacts-#{contact.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#contacts-#{contact.id}")
    end
  end

  describe "Show" do
    setup [:create_contact]

    test "displays contact", %{conn: conn, contact: contact} do
      {:ok, _show_live, html} = live(conn, ~p"/contacts/#{contact}")

      assert html =~ "Show Contact"
      assert html =~ contact.name
    end

    test "updates contact and returns to show", %{conn: conn, contact: contact} do
      {:ok, show_live, _html} = live(conn, ~p"/contacts/#{contact}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/contacts/#{contact}/edit?return_to=show")

      assert render(form_live) =~ "Edit Contact"

      assert form_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#contact-form", contact: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/contacts/#{contact}")

      html = render(show_live)
      assert html =~ "Contact updated successfully"
      assert html =~ "some updated name"
    end
  end
end
