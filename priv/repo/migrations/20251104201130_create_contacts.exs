defmodule ContactsApplication.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string
      add :phone, :string
      add :email, :string
      add :notes, :text

      timestamps(type: :utc_datetime)
    end

    # Ensure quick lookup and data integrity
    create unique_index(:contacts, [:email])
  end
end
