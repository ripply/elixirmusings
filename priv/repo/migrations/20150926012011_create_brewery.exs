defmodule Beermusings.Repo.Migrations.CreateBrewery do
  use Ecto.Migration

  def change do
    create table(:brewery) do
      add :name, :string
      add :address1, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :code, :string
      add :country, :string
      add :phone, :string
      add :website, :string
      add :filepath, :string
      add :descript, :text
      add :add_user, :integer
      add :last_mod, :datetime

      timestamps
    end

  end
end
