defmodule Homer.Search.Server do
  @moduledoc """
  Implementation of Homer.Search.ServerBehaviour
  """

  use GenServer

  alias Homer.Search.Offer

  @behaviour Homer.Search.ServerBehaviour

  @idle_timeout_ms 15 * 60 * 1000

  @impl true
  def start_link({_offer_request, _providers} = init_arg),
    do: GenServer.start_link(__MODULE__, init_arg, [{:name, :search_server}])

  @impl true
  def list_offers(pid, limit), do: GenServer.call(pid, {:list_offers, limit}, 120_000)

  @impl true
  def offer_request_updated(pid, offer_request),
    do: GenServer.cast(pid, {:offer_request_updated, offer_request})

  # Callbacks

  @impl true
  def init({offer_request, providers}),
    do: {:ok, touch_idle_timer({offer_request, providers, nil})}

  # We assume the fact that today there is only one possible provider : Duffel.
  # When there are some, we will have to query each of them and aggregate the results.
  @impl true
  def handle_call({:list_offers, limit}, _from, {offer_request, [provider], _} = state) do
    reply =
      case provider.fetch_offers(offer_request) do
        {:ok, offers} -> {:ok, offers |> sort_offers(offer_request) |> Enum.take(limit)}
        error -> error
      end

    {:reply, reply, touch_idle_timer(state)}
  end

  @impl true
  def handle_cast({:offer_request_updated, offer_request}, {_, providers, idle_timeout_ref}),
    do: {:noreply, touch_idle_timer({offer_request, providers, idle_timeout_ref})}

  # we got our idle timeout let's clean it up
  @impl true
  def handle_info(
        {:idle_timeout, idle_timeout_ref},
        {_, _, idle_timeout_ref} = state
      ),
      do: {:stop, :shutdown, state}

  # we have an old timeout coming through, we should just ignore it
  @impl true
  def handle_info({:idle_timeout, _ref}, state), do: {:noreply, state}

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

  defp touch_idle_timer({offer_request, providers, _}) do
    idle_timeout_ref = make_ref()
    Process.send_after(self(), {:idle_timeout, idle_timeout_ref}, @idle_timeout_ms)
    {offer_request, providers, idle_timeout_ref}
  end
end
