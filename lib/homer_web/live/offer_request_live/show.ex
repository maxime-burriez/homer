defmodule HomerWeb.OfferRequestLive.Show do
  @moduledoc """
  HomerWeb.OfferRequestLive.Show
  """

  use HomerWeb, :live_view

  alias Homer.Search

  @number_of_offers_limit 10

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    offer_request = Search.get_offer_request!(id)
    Process.send(self(), {:update_offers, offer_request}, [:noconnect])

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:offer_request, offer_request)
     |> assign(:offers, [])}
  end

  @impl true
  def handle_info({:update_offers, offer_request}, socket) do
    {:ok, offers} = Search.get_offers(offer_request, @number_of_offers_limit)

    {:noreply, assign(socket, :offers, offers)}
  end

  defp page_title(:show), do: "Show Offer request"
  defp page_title(:edit), do: "Edit Offer request"
end
