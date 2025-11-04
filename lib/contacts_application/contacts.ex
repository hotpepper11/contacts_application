defmodule ContactsApplication.Contacts do
  @moduledoc """
  The Contacts context module, handling all business logic
  related to Contact records.
  """
  import Ecto.Query, warn: false
  alias ContactsApplication.Repo
  alias ContactsApplication.Contact

  # --- Read Operations ---

  @doc "Returns the list of all contacts."
  def list_contacts do
    Repo.all(Contact)
  end

  @doc "Gets a single contact by ID. Raises if not found."
  def get_contact!(id), do: Repo.get!(Contact, id)

  # --- Write Operations (CRUD) ---

  @doc "Creates a new contact with the given attributes."
  def create_contact(attrs) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Updates an existing contact with the given attributes."
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc "Deletes the given contact."
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @doc "Returns an %Ecto.Changeset{} for form handling."
  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end
end
