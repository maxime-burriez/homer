defmodule HomerWeb.OfferRequestLive.FormComponent do
  @moduledoc """
  HomerWeb.OfferRequestLive.FormComponent
  """

  use HomerWeb, :live_component

  alias Homer.Search

  @impl true
  def update(%{offer_request: offer_request, action: action} = assigns, socket) do
    changeset = Search.change_offer_request(offer_request)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:is_editing, action == :edit)
     |> assign(
       :all_airlines_selected,
       is_nil(Ecto.Changeset.get_field(changeset, :allowed_airlines))
     )
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"offer_request" => offer_request_params}, socket) do
    offer_request_params = prepare_offer_request_params(offer_request_params)

    changeset =
      socket.assigns.offer_request
      |> Search.change_offer_request(offer_request_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(
       :all_airlines_selected,
       is_nil(Ecto.Changeset.get_field(changeset, :allowed_airlines))
     )
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"offer_request" => offer_request_params}, socket) do
    offer_request_params = prepare_offer_request_params(offer_request_params)

    save_offer_request(socket, socket.assigns.action, offer_request_params)
  end

  defp prepare_offer_request_params(%{"all_airlines" => "true"} = offer_request_params),
    do: Map.put(offer_request_params, "allowed_airlines", nil)

  defp prepare_offer_request_params(%{"allowed_airlines" => _} = offer_request_params),
    do: offer_request_params

  defp prepare_offer_request_params(offer_request_params),
    do: Map.put(offer_request_params, "allowed_airlines", [])

  defp save_offer_request(socket, :edit, offer_request_params) do
    case Search.update_offer_request(socket.assigns.offer_request, offer_request_params) do
      {:ok, _offer_request} ->
        {:noreply,
         socket
         |> put_flash(:info, "Offer request updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_offer_request(socket, :new, offer_request_params) do
    case Search.create_offer_request(offer_request_params) do
      {:ok, _offer_request} ->
        {:noreply,
         socket
         |> put_flash(:info, "Offer request created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
