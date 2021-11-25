defmodule Homer.Search.Offer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "offers" do
    field :arriving_at, :naive_datetime
    field :departing_at, :naive_datetime
    field :destination, :string
    field :origin, :string
    field :segments_count, :integer
    field :total_amount, :decimal
    field :total_duration, :integer

    timestamps()
  end

  @doc false
  def changeset(offer, attrs) do
    offer
    |> cast(attrs, [
      :origin,
      :destination,
      :departing_at,
      :arriving_at,
      :segments_count,
      :total_amount,
      :total_duration
    ])
    |> validate_required([
      :origin,
      :destination,
      :departing_at,
      :arriving_at,
      :segments_count,
      :total_amount,
      :total_duration
    ])
  end
end
