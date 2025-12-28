defmodule PlainaidWeb.SimplifierLive.Index do
  use PlainaidWeb, :live_view
  alias Plainaid.Simplifier

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:text_input, "")
     |> assign(:result, nil)
     |> assign(:mode, "simplify")
     |> assign(:loading, false)}
  end

  @impl true
  def handle_event("set_mode", %{"mode" => mode}, socket) do
    {:noreply, assign(socket, :mode, mode)}
  end

  @impl true
  def handle_event("simplify", %{"text" => text}, socket) when text != "" do
    send(self(), {:process_text, text, socket.assigns.mode})
    {:noreply, assign(socket, :loading, true)}
  end

  @impl true
  def handle_info({:process_text, text, mode}, socket) do
    {:noreply,
     socket
     |> assign(:result, Simplifier.simplify(text, mode))
     |> assign(:loading, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <!-- PAGE BACKGROUND -->
    <div class="min-h-screen bg-gradient-to-br from-slate-50 via-indigo-50 to-slate-100 py-12">

      <!-- MAIN CARD -->
      <div class="max-w-4xl mx-auto bg-white rounded-2xl shadow-xl p-8">

        <div class="mb-8 text-center">
          <h1 class="text-4xl font-bold text-indigo-700 mb-2">PlainAid</h1>
          <p class="text-slate-600 text-lg">
            Transform complex text into clear, actionable information
          </p>
        </div>

        <form phx-submit="simplify" class="space-y-6">
          <textarea
            name="text"
            rows="10"
            class="w-full rounded-xl border border-slate-300 p-4 text-slate-800
                   focus:ring-2 focus:ring-indigo-400 focus:border-indigo-400"
            placeholder="Paste any complex text here..."
          ><%= @text_input %></textarea>

          <!-- MODES -->
          <div class="grid md:grid-cols-2 gap-4">
            <%= for {id, label, desc} <- [
              {"simplify", "📝 Simplify", "Make text easier to understand"},
              {"structure", "🗂️ Structure", "Organize text into actions"}
            ] do %>
              <label class={"p-4 rounded-xl border cursor-pointer transition
                #{if @mode == id,
                  do: "bg-indigo-50 border-indigo-400",
                  else: "bg-slate-50 border-slate-200"}"}>
                <input
                  type="radio"
                  name="mode"
                  value={id}
                  checked={@mode == id}
                  phx-click="set_mode"
                  phx-value-mode={id}
                  class="hidden"
                />
                <div class="font-semibold text-slate-900"><%= label %></div>
                <p class="text-sm text-slate-600 mt-1"><%= desc %></p>
              </label>
            <% end %>
          </div>

          <button
            type="submit"
            disabled={@loading}
            class="w-full bg-indigo-500 text-white py-3 rounded-xl font-medium
                   hover:bg-indigo-600 transition shadow-md"
          >
            <%= if @loading, do: "Processing…", else: "Run" %>
          </button>
        </form>

<%= if @result do %>
  <div class="mt-10 space-y-6">

    <!-- SUMMARY -->
    <div class="bg-indigo-50 p-6 rounded-xl border border-indigo-100">
      <h3 class="font-semibold text-indigo-800 mb-2">📋 Summary</h3>
      <p class="text-slate-800 leading-relaxed">
        <%= @result["summary"] %>
      </p>
    </div>

    <%= if @result["required_actions"] && @result["required_actions"] != [] do %>
      <div class="bg-rose-50 p-6 rounded-xl border border-rose-100">
        <h3 class="font-semibold text-slate-900 mb-2">⚠️ Required Actions</h3>
        <ul class="space-y-2">
          <%= for action <- @result["required_actions"] do %>
            <li class="text-slate-800">• <%= action %></li>
          <% end %>
        </ul>
      </div>
    <% end %>

    <%= if @result["deadlines"] && @result["deadlines"] != [] do %>
      <div class="bg-amber-50 p-6 rounded-xl border border-amber-100">
        <h3 class="font-semibold text-slate-900 mb-2">⏰ Deadlines</h3>
        <ul class="space-y-2">
          <%= for d <- @result["deadlines"] do %>
            <li class="text-slate-800">• <%= d %></li>
          <% end %>
        </ul>
      </div>
    <% end %>

    <%= if @result["risks"] && @result["risks"] != [] do %>
      <div class="bg-orange-50 p-6 rounded-xl border border-orange-100">
        <h3 class="font-semibold text-slate-900 mb-2">🚨 Risks</h3>
        <ul class="space-y-2">
          <%= for r <- @result["risks"] do %>
            <li class="text-slate-800">• <%= r %></li>
          <% end %>
        </ul>
      </div>
    <% end %>

    <%= if @result["optional"] && @result["optional"] != [] do %>
      <div class="bg-emerald-50 p-6 rounded-xl border border-emerald-100">
        <h3 class="font-semibold text-slate-900 mb-2">✓ Optional</h3>
        <ul class="space-y-2">
          <%= for o <- @result["optional"] do %>
            <li class="text-slate-800">• <%= o %></li>
          <% end %>
        </ul>
      </div>
    <% end %>

  </div>
<% end %>
      </div>

      <!-- FOOTER (SELF-CONTAINED STYLE) -->
      <footer style="
        margin-top: 80px;
        padding: 40px 20px;
        background: linear-gradient(135deg, #312e81, #4f46e5);
        color: #e0e7ff;
        text-align: center;
        font-family: system-ui;
      ">
        <div style="max-width: 900px; margin: auto;">
          <div style="font-size: 18px; font-weight: 600;">
            Built with ❤️ by Mohammad Ali Abdul Wahed
          </div>

          <div style="margin-top: 8px; opacity: 0.85;">
            Developer • Creator • Open Source Enthusiast
          </div>

          <div style="margin-top: 20px; display: flex; justify-content: center; gap: 16px;">
            <a href="https://github.com/aliabdm" target="_blank" style="color:#c7d2fe;">GitHub</a>
            <a href="https://linkedin.com/in/mohammad-ali-abdul-wahed-1533b9171/" target="_blank" style="color:#c7d2fe;">LinkedIn</a>
            <a href="https://medium.com/@aliabdm" target="_blank" style="color:#c7d2fe;">Medium</a>
          </div>

          <div style="margin-top: 30px; font-size: 14px; opacity: 0.6;">
            © 2025 Mohammad Ali Abdul Wahed
          </div>
        </div>
      </footer>

    </div>
    """
  end
end
