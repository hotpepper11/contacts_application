defmodule ContactsManager.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :name, :string
    field :phone, :string
    field :email, :string
    field :notes, :string
    timestamps()
  end

  @doc """
  Generates a changeset for contact creation and updates.
  """
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :phone, :email, :notes])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end
end
