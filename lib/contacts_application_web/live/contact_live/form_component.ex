defmodule ContactsApplicationWeb.ContactLive.FormComponent do
  use ContactsApplicationWeb, :live_component

  alias ContactsApplication.Contacts

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("validate", %{"contact" => contact_params}, socket) do
    changeset =
      socket.assigns.contact
      |> Contacts.change_contact(contact_params)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"contact" => contact_params}, socket) do
    save_contact(socket, socket.assigns.action, contact_params)
  end

  defp save_contact(socket, :edit, contact_params) do
    case Contacts.update_contact(socket.assigns.contact, contact_params) do
      {:ok, contact} ->
        send(self(), {__MODULE__, {:saved, contact}})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_contact(socket, :new, contact_params) do
    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        send(self(), {__MODULE__, {:saved, contact}})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
