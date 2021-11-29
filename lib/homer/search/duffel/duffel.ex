defmodule Homer.Search.Duffel do
  @moduledoc """
  Implementation of Homer.Search.ProviderBehaviour for Duffel-related code
  """

  @behaviour Homer.Search.ProviderBehaviour

  def fetch_offers(offer_request), do: duffel_module().fetch_offers(offer_request)

  defp duffel_module, do: Application.get_env(:homer, :duffel_module)
end
