defmodule Beermusings.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :string
      add :beer_id, references(:beers)

      timestamps
    end
    create index(:posts, [:beer_id])

  end
end
