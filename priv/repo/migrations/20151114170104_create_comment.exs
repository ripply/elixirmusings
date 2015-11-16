defmodule Beermusings.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :post_id, references(:posts)

      timestamps
    end
    create index(:comments, [:post_id])

  end
end
