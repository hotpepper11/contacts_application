defmodule ContactsApplicationWeb.PageController do
  use ContactsApplicationWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
