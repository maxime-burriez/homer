defmodule Homer.Repo.Migrations.CreateOffers do
  use Ecto.Migration

  def change do
    create table(:offers) do
      add :origin, :string
      add :destination, :string
      add :departing_at, :naive_datetime
      add :arriving_at, :naive_datetime
      add :segments_count, :integer
      add :total_amount, :decimal
      add :total_duration, :integer

      timestamps()
    end
  end
end
