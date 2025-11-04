defmodule ContactsApplicationWeb.ContactLive.Index do
  use ContactsApplicationWeb, :live_view
  use Phoenix.LiveView

  alias ContactsApplication.Contacts
  alias ContactsApplication.Contact

  @impl true
  def mount(_params, _session, socket) do
    contacts = Contacts.list_contacts()
    socket = assign(socket, :contacts, contacts)
    socket = stream(socket, :contacts, contacts)

    {:ok, socket}
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
  def handle_event("create_contact", _params, socket) do
    # Attributes for the new record
    attrs = %{name: "New Item (Default)", email: "test@example.com", phone: "asd", notes: "df", title: "New"}

    case Contacts.create_contact(attrs) do
      {:ok, new_contact} ->
        socket = put_flash(socket, :info, "Contact successfully created!")

        socket = LiveStream.insert(socket, :contacts, new_contact)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors, label: "Contact Creation Failed")
        {:noreply, put_flash(socket, :error, "Failed to create contact. Check logs for validation errors.")}
    end
  end



  @impl true
  # Ensures the saved contact is efficiently streamed onto the list
  def handle_info({ContactsApplicationWeb.ContactLive.FormComponent, {:saved, contact}}, socket) do
    {:noreply, stream_insert(socket, :contacts, contact)}
  end
end
