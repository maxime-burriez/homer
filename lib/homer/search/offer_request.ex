defmodule Homer.Search.OfferRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offer_requests" do
    field :allowed_airlines, {:array, :string}
    field :departure_date, :date
    field :destination, :string
    field :origin, :string
    field :sort_by, Ecto.Enum, values: [:total_amount, :total_duration]

    timestamps()
  end

  @doc false
  def changeset(offer_request, attrs) do
    offer_request
    |> cast(attrs, [:origin, :destination, :departure_date, :sort_by, :allowed_airlines])
    |> validate_required([:origin, :destination, :departure_date, :sort_by, :allowed_airlines])
  end
end
