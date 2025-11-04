defmodule ContactsApplicationWeb.ContactLive.Index do
  # NOTE: The module name MUST match your core application name: ContactsApplication
  use ContactsApplicationWeb, :live_view

  # Correct Context Alias: Context lives in the core app, NOT the Web app.
  alias ContactsApplication.Contacts
  alias ContactsApplication.Contact

  @impl true
  def mount(_params, _session, socket) do
    # FIX: Initialize :contacts as a stream. This is required for stream_insert/delete
    # and the rendering helpers used in the HTML template.
    socket = stream(socket, :contacts, Contacts.list_contacts())
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # Handles the root route defined as :index
  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Contacts")
    |> assign(:contact, nil)
  end

  # Catch the :render action that LiveView sometimes sends during initial mount
  defp apply_action(socket, :render, _params) do
    apply_action(socket, :index, _params)
  end

  defp apply_action(socket, :new, _params) do
    changeset = Contacts.change_contact(%Contact{})

    socket
    |> assign(:page_title, "New Contact")
    |> assign(:contact, changeset)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    changeset = Contacts.change_contact(contact)

    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:contact, changeset)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = Contacts.get_contact!(id)
    {:ok, _} = Contacts.delete_contact(contact)

    # Use stream_delete to update the list efficiently on the client side
    {:noreply, stream_delete(socket, :contacts, contact)}
  end

  @impl true
  # Ensures the saved contact is efficiently streamed onto the list
  def handle_info({ContactsApplicationWeb.ContactLive.FormComponent, {:saved, contact}}, socket) do
    {:noreply, stream_insert(socket, :contacts, contact)}
  end
end
