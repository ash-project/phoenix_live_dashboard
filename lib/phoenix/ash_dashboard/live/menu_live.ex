defmodule AshDashboard.MenuLive do
  use AshDashboard.Web, :live_view

  @impl true
  def mount(_, %{"menu" => menu}, socket) do
    socket = assign(socket, menu: menu)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <nav id="menu-bar">
      <%= maybe_active_live_redirect @socket, @menu, "Home", :home %>
    </nav>
    """
  end

  defp maybe_active_live_redirect(socket, menu, text, action) do
    if menu.action == action do
      content_tag(:div, text, class: "menu-item active")
    else
      live_redirect(text, to: ash_dashboard_path(socket, action), class: "menu-item")
    end
  end

  defp maybe_enabled_live_redirect(socket, menu, text, action) do
    if menu[action] do
      maybe_active_live_redirect(socket, menu, text, action)
    else
      assigns = %{action: action, text: text}

      ~L"""
      <div class="menu-item menu-item-disabled">
        <%= @text %> <%= link "Enable", to: guide(@action), class: "menu-item-enable-button" %>
      </div>
      """
    end
  end

  defp guide(name), do: "https://hexdocs.pm/ash_dashboard/#{name}.html"
end
