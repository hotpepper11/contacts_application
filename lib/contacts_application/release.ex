defmodule ContactsApplication.Release do
  @moduledoc """
  Handles tasks specific to the application release, primarily Ecto migrations.
  """
  alias ContactsApplication.Repo

  def migrate do
    # 1. Start the Ecto application/supervision tree temporarily
    # This is necessary when running a simple `eval` command outside the full supervision tree
    {:ok, _} = Application.ensure_started(:ecto)

    # 2. Run the Ecto migrations
    # storage_up ensures the database exists if it hasn't been created yet
    Repo.__adapter__.storage_up(Repo.config())
    Ecto.Migrator.run(Repo, :up, all: true)

    # 3. Log completion
    IO.puts "Database migrations completed successfully."
    :ok
  end
end
