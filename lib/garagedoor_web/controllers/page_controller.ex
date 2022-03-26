defmodule GaragedoorWeb.PageController do
  use GaragedoorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
