defmodule ContactsApplication.Repo do
  use Ecto.Repo,
    otp_app: :contacts_application,
    adapter: Ecto.Adapters.Postgres
end
