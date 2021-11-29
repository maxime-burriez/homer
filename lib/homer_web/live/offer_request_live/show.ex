defmodule HomerWeb.OfferRequestLive.Show do
  use HomerWeb, :live_view

  alias Homer.Search

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:offer_request, Search.get_offer_request!(id))}
  end

  defp page_title(:show), do: "Show Offer request"
  defp page_title(:edit), do: "Edit Offer request"
end
