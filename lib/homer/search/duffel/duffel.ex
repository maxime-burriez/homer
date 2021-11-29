defmodule Homer.Search.Duffel do
  @moduledoc """
  Implementation of Homer.Search.ProviderBehaviour for Duffel-related code
  """

  @behaviour Homer.Search.ProviderBehaviour

  @module Application.get_env(:homer, :duffel_module)

  defdelegate fetch_offers(offer_request), to: @module
end
