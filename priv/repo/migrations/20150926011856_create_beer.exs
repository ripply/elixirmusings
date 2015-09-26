defmodule Beermusings.Repo.Migrations.CreateBeer do
  use Ecto.Migration

  def change do
    create table(:beers) do
      add :brewery_id, :integer
      add :name, :string
      add :cat_id, :integer
      add :style_id, :integer
      add :abv, :float
      add :ibu, :float
      add :srm, :float
      add :upc, :integer
      add :filepath, :string
      add :descript, :text
      add :add_user, :integer
      add :last_mod, :datetime

      timestamps
    end

  end
end
