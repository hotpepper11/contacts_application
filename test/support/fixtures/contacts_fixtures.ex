defmodule ContactsApplication.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ContactsApplication.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        notes: "some notes",
        phone: "some phone"
      })
      |> ContactsApplication.Contacts.create_contact()

    contact
  end
end
