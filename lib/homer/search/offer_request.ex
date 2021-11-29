defmodule Homer.Search.OfferRequest do
  @moduledoc """
  Homer.Search.OfferRequest
  """

  use Ecto.Schema
  import Ecto.Changeset

  @fields ~w(origin destination departure_date sort_by allowed_airlines)a
  @required_fields ~w(origin destination departure_date sort_by)a
  @sorts ~w(total_amount_asc total_amount_desc total_duration_asc total_duration_desc)a
  @iata_airport_format ~r/^[A-Z]{3}$/

  schema "offer_requests" do
    field :allowed_airlines, {:array, :string}
    field :departure_date, :date
    field :destination, :string
    field :origin, :string
    field :sort_by, Ecto.Enum, values: @sorts

    timestamps()
  end

  @doc false
  def changeset(offer_request, attrs, permitted \\ @fields) do
    offer_request
    |> cast(attrs, permitted)
    |> put_defaults
    |> validate_required(@required_fields)
    |> validate_format(:origin, @iata_airport_format)
    |> validate_format(:destination, @iata_airport_format)
  end

  @doc false
  def create_changeset(offer_request, attrs),
    do: changeset(offer_request, attrs, ~w(origin destination departure_date)a)

  @doc false
  def update_changeset(offer_request, attrs),
    do: changeset(offer_request, attrs, ~w(sort_by allowed_airlines)a)

  defp put_defaults(changeset), do: put_default_sort_by(changeset)

  defp put_default_sort_by(changeset) do
    if Enum.member?(@sorts, get_field(changeset, :sort_by)) do
      changeset
    else
      put_change(changeset, :sort_by, :total_amount_asc)
    end
  end
end
