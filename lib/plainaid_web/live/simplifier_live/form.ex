defmodule PlainaidWeb.SimplifierLive.Form do
  use PlainaidWeb, :live_view

  alias Plainaid.Simplifier

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Paste text below to simplify it.</:subtitle>
      </.header>

      <.form for={@form} id="simplifier-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:content]} type="text" label="Text to Simplify" />
        <footer>
          <.button phx-disable-with="Simplifying..." variant="primary">Simplify</.button>
        </footer>
      </.form>

      <%= if @result do %>
        <h3>Summary:</h3>
        <p><%= @result["summary"] %></p>

        <h4>Points:</h4>
        <ul>
          <%= for point <- @result["points"] do %>
            <li><%= point %></li>
          <% end %>
        </ul>
      <% end %>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Text Simplifier")
     |> assign(:form, to_form(%{content: ""}))
     |> assign(:result, nil)}
  end

  @impl true
  def handle_event("validate", %{"simplifier" => %{"content" => content}}, socket) do
    # نحافظ على قيمة النص داخل الفورم
    {:noreply, assign(socket, form: to_form(%{content: content}))}
  end

  @impl true
  def handle_event("save", %{"simplifier" => %{"content" => content}}, socket) do
    # استدعاء الدالة simplify مباشرة
    result = Simplifier.simplify(content)

    {:noreply,
     socket
     |> assign(:result, result)
     |> assign(:form, to_form(%{content: content}))}
  end
end
