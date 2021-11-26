defmodule Homer.Search.Duffel.Core do
  @moduledoc """
  Core module for Duffel in dev/prod environments
  """

  use Tesla

  alias Homer.Search.Offer

  plug Tesla.Middleware.BaseUrl, config()[:duffel_api_host]
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.DecompressResponse, format: "gzip"

  plug Tesla.Middleware.Headers, [
    {"Accept-Encoding", "gzip"},
    {"Accept", "application/json"},
    {"Content-Type", "application/json"},
    {"Duffel-Version", config()[:duffel_version]},
    {"Authorization", "Bearer " <> config()[:duffel_token]}
  ]

  def config, do: Application.get_env(:homer, __MODULE__)

  def fetch_offers(offer_request) do
    request_body = build_request_body(offer_request)

    case post("/offer_requests", request_body, opts: [adapter: [recv_timeout: 120_000]]) do
      {:ok, %{status: _status, body: body}} -> {:ok, extract_offers(body)}
      error -> error
    end
  end

  defp build_request_body(offer_request) do
    # /!\ In order to simplify this exercise, let's say that we can only search for one-way tickets for an adult.

    Jason.encode!(%{
      data: %{
        slices: [
          %{
            origin: offer_request.origin,
            destination: offer_request.destination,
            departure_date: offer_request.departure_date
          }
        ],
        passengers: [%{type: "adult"}]
      }
    })
  end

  defp extract_offers(%{"data" => %{"offers" => offers_attrs}}),
    do:
      Enum.map(offers_attrs, fn offer_attrs ->
        # For offer_attrs, Duffel's documentation explains that all lists of slices and segments will be ordered by those departing first.
        # In order to simplify this exercise, let's say that we can only search for one-way tickets for an adult. Therefore, we will only have one slice per offer.

        segments = List.first(offer_attrs["slices"])["segments"]
        segments_count = Enum.count(segments)
        first_segment = List.first(segments)
        last_segment = List.last(segments)

        attrs = %{
          origin: first_segment["origin"]["iata_code"],
          destination: last_segment["destination"]["iata_code"],
          departing_at: first_segment["departing_at"],
          arriving_at: last_segment["arriving_at"],
          segments_count: segments_count,
          total_amount: offer_attrs["total_amount"],
          total_duration: total_duration(segments)
        }

        %Offer{}
        |> Offer.changeset(attrs)
        |> Ecto.Changeset.apply_changes()
      end)

  defp extract_offers(_), do: []

  defp total_duration(segments) when is_list(segments),
    do:
      Enum.reduce(segments, 0, fn segment, total_acc ->
        with {:ok, duration} <-
               Timex.Parse.Duration.Parsers.ISO8601Parser.parse(segment["duration"]) do
          total_acc + Timex.Duration.to_minutes(duration, truncate: true)
        else
          _ -> total_acc
        end
      end)

  defp total_duration(_), do: 0
end
