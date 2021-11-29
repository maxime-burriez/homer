defmodule HomerWeb.OfferRequestLive.Index do
  use HomerWeb, :live_view

  alias Homer.Search
  alias Homer.Search.OfferRequest

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :offer_requests, list_offer_requests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Offer request")
    |> assign(:offer_request, Search.get_offer_request!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Offer request")
    |> assign(:offer_request, %OfferRequest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Offer requests")
    |> assign(:offer_request, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    offer_request = Search.get_offer_request!(id)
    {:ok, _} = Search.delete_offer_request(offer_request)

    {:noreply, assign(socket, :offer_requests, list_offer_requests())}
  end

  defp list_offer_requests do
    Search.list_offer_requests()
  end
end
