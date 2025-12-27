defmodule PlainaidWeb.PageController do
  use PlainaidWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
