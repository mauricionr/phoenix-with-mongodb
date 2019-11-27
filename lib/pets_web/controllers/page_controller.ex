defmodule PetsWeb.PageController do
  use PetsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
