defmodule Beermusings.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :weight, :integer
      add :post_id, references(:posts)

      timestamps
    end
    create index(:votes, [:post_id])

  end
end
