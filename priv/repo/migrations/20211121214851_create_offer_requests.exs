defmodule Homer.Repo.Migrations.CreateOfferRequests do
  use Ecto.Migration

  def change do
    create table(:offer_requests) do
      add :origin, :string
      add :destination, :string
      add :departure_date, :date
      add :sort_by, :string
      add :allowed_airlines, {:array, :string}

      timestamps()
    end
  end
end
