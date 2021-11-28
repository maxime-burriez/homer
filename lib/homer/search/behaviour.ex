defmodule Homer.Search.Behaviour do
  @callback list_offer_requests() :: [OfferRequest.t()]

  @callback get_offer_request!(id :: integer()) :: OfferRequest.t()

  @callback create_offer_request(attrs :: map()) :: {:ok, OfferRequest.t()} | {:error, any()}

  @callback update_offer_request(OfferRequest.t(), attrs :: map()) ::
              {:ok, OfferRequest.t()} | {:error, any()}

  @callback get_offers(OfferRequest.t(), limit :: integer()) ::
              {:ok, [Offer.t()]} | {:error, any()}
end
