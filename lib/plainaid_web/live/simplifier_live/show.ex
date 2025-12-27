defmodule PlainaidWeb.SimplifierLive.Show do
  use PlainaidWeb, :live_view

  alias Plainaid.Text

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Simplifier {@simplifier.id}
        <:subtitle>This is a simplifier record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/simplify_text"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/simplify_text/#{@simplifier}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit simplifier
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Content">{@simplifier.content}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Simplifier")
     |> assign(:simplifier, Text.get_simplifier!(id))}
  end
end
