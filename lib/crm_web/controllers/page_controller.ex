defmodule CrmWeb.PageController do
  use CrmWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def components(conn, _params) do
    render(conn, "components.html")
  end
end
