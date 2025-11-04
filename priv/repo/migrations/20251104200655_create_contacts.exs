defmodule ContactsManager.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string, null: false
      add :phone, :string
      add :email, :string, null: false
      add :notes, :text
      timestamps()
    end

    # Ensure quick lookup and data integrity
    create unique_index(:contacts, [:email])
  end
end
