defmodule PlainaidWeb.Router do
  use PlainaidWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PlainaidWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlainaidWeb do
    pipe_through :browser

    live "/", SimplifierLive.Index
  end
end