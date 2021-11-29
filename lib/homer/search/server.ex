defmodule Homer.Search.Server do
  @moduledoc """
  Implementation of Homer.Search.ServerBehaviour
  """

  use GenServer

  alias Homer.Search.Offer

  @behaviour Homer.Search.ServerBehaviour

  @impl true
  def start_link({_offer_request, _providers} = init_arg),
    do: GenServer.start_link(__MODULE__, init_arg)

  @impl true
  def list_offers(pid, limit), do: GenServer.call(pid, {:list_offers, limit}, 120_000)

  @impl true
  def offer_request_updated(pid, offer_request),
    do: GenServer.cast(pid, {:offer_request_updated, offer_request})

  # Callbacks

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_call({:list_offers, limit}, _from, {offer_request, [provider]} = state) do
    with {:ok, offers} <- provider.fetch_offers(offer_request) do
      {:reply, {:ok, offers |> sort_offers(offer_request) |> Enum.take(limit)}, state}
    else
      error -> error
    end
  end

  @impl true
  def handle_cast({:offer_request_updated, offer_request}, {_, providers}),
    do: {:noreply, {offer_request, providers}}

  defp sort_offers([%Offer{} | _] = offers, %{sort_by: sort_by}) when is_atom(sort_by) do
    splited_str = sort_by |> Atom.to_string() |> String.split("_")
    {order, splited_field_name} = List.pop_at(splited_str, -1)
    field_name = splited_field_name |> Enum.join("_") |> String.to_atom()

    if Enum.member?(["asc", "desc"], order) do
      order = String.to_atom(order)
      Enum.sort_by(offers, &Map.get(&1, field_name), order)
    else
      offers
    end
  end

  defp sort_offers(offers, _), do: offers
end
