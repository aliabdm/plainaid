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
    mode = socket.assigns.mode
    
    # Send to background process
    send(self(), {:process_text, text, mode})
    
    {:noreply, assign(socket, :loading, true)}
  end

  @impl true
  def handle_event("simplify", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:process_text, text, mode}, socket) do
    result = Simplifier.simplify(text, mode)
    
    {:noreply,
     socket
     |> assign(:result, result)
     |> assign(:loading, false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-6">
      <div class="mb-8">
        <h1 class="text-4xl font-bold mb-2 text-gray-900">PlainAid</h1>
        <p class="text-lg text-gray-600">Transform complex text into clear, actionable information</p>
      </div>

      <form phx-submit="simplify" class="space-y-6">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">
            Enter your text
          </label>
          <textarea
            name="text"
            rows="10"
            class="w-full border border-gray-300 rounded-lg p-4 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 text-gray-900"
            placeholder="Paste official letters, legal documents, bank notices, or any text you need help understanding..."
          ><%= @text_input %></textarea>
        </div>

        <!-- Mode Selection -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <label class={"flex items-start gap-3 p-4 border-2 rounded-lg cursor-pointer transition-all hover:border-indigo-300 #{if @mode == "simplify", do: "border-indigo-500 bg-indigo-50", else: "border-gray-200 bg-white"}"}>
            <input
              type="radio"
              name="mode"
              value="simplify"
              checked={@mode == "simplify"}
              phx-click="set_mode"
              phx-value-mode="simplify"
              class="mt-1 w-4 h-4 text-indigo-600"
            />
            <div>
              <span class="font-semibold text-gray-900 block">📝 Simplify</span>
              <p class="text-sm text-gray-600 mt-1">
                For complex, formal, or legal text that needs to be made easier to understand
              </p>
            </div>
          </label>

          <label class={"flex items-start gap-3 p-4 border-2 rounded-lg cursor-pointer transition-all hover:border-indigo-300 #{if @mode == "structure", do: "border-indigo-500 bg-indigo-50", else: "border-gray-200 bg-white"}"}>
            <input
              type="radio"
              name="mode"
              value="structure"
              checked={@mode == "structure"}
              phx-click="set_mode"
              phx-value-mode="structure"
              class="mt-1 w-4 h-4 text-indigo-600"
            />
            <div>
              <span class="font-semibold text-gray-900 block">🗂️ Structure</span>
              <p class="text-sm text-gray-600 mt-1">
                For clear text that needs better organization and actionable breakdown
              </p>
            </div>
          </label>
        </div>

        <div class="flex gap-3">
          <button
            type="submit"
            disabled={@loading}
            class="bg-indigo-600 text-white px-6 py-3 rounded-lg hover:bg-indigo-700 transition-colors font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <%= if @loading do %>
              <span class="flex items-center gap-2">
                <svg class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Processing...
              </span>
            <% else %>
              <%= if @mode == "simplify", do: "Simplify Text", else: "Structure Text" %>
            <% end %>
          </button>
          
          <button type="reset" class="bg-gray-200 px-6 py-3 rounded-lg hover:bg-gray-300 transition-colors font-medium">
            Clear
          </button>
        </div>
      </form>

      <%= if @result do %>
        <div class="mt-10 space-y-6">
          <!-- Summary -->
          <div class="p-6 bg-blue-50 rounded-lg shadow-sm border border-blue-100">
            <h2 class="text-xl font-semibold mb-3 text-blue-900 flex items-center gap-2">
              <span>📋</span> Summary
            </h2>
            <p class="text-gray-800 leading-relaxed"><%= @result["summary"] %></p>
          </div>

          <!-- Required Actions -->
          <%= if @result["required_actions"] && length(@result["required_actions"]) > 0 do %>
            <div class="p-6 bg-red-50 rounded-lg shadow-sm border border-red-100">
              <h2 class="text-xl font-semibold mb-3 text-red-900 flex items-center gap-2">
                <span>⚠️</span> What You Must Do
              </h2>
              <ul class="space-y-2">
                <%= for action <- @result["required_actions"] do %>
                  <li class="flex items-start gap-2 text-gray-800">
                    <span class="text-red-600 font-bold">•</span>
                    <span><%= action %></span>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>

          <!-- Deadlines -->
          <%= if @result["deadlines"] && length(@result["deadlines"]) > 0 do %>
            <div class="p-6 bg-yellow-50 rounded-lg shadow-sm border border-yellow-100">
              <h2 class="text-xl font-semibold mb-3 text-yellow-900 flex items-center gap-2">
                <span>⏰</span> Important Deadlines
              </h2>
              <ul class="space-y-2">
                <%= for deadline <- @result["deadlines"] do %>
                  <li class="flex items-start gap-2 text-gray-800">
                    <span class="text-yellow-600 font-bold">•</span>
                    <span><%= deadline %></span>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>

          <!-- Risks -->
          <%= if @result["risks"] && length(@result["risks"]) > 0 do %>
            <div class="p-6 bg-orange-50 rounded-lg shadow-sm border border-orange-100">
              <h2 class="text-xl font-semibold mb-3 text-orange-900 flex items-center gap-2">
                <span>🚨</span> Risks if You Don't Act
              </h2>
              <ul class="space-y-2">
                <%= for risk <- @result["risks"] do %>
                  <li class="flex items-start gap-2 text-gray-800">
                    <span class="text-orange-600 font-bold">•</span>
                    <span><%= risk %></span>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>

          <!-- Optional -->
          <%= if @result["optional"] && length(@result["optional"]) > 0 do %>
            <div class="p-6 bg-green-50 rounded-lg shadow-sm border border-green-100">
              <h2 class="text-xl font-semibold mb-3 text-green-900 flex items-center gap-2">
                <span>✓</span> Optional (Not Required)
              </h2>
              <ul class="space-y-2">
                <%= for opt <- @result["optional"] do %>
                  <li class="flex items-start gap-2 text-gray-800">
                    <span class="text-green-600 font-bold">•</span>
                    <span><%= opt %></span>
                  </li>
                <% end %>
              </ul>
            </div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end