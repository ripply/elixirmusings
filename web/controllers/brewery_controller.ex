defmodule Beermusings.BreweryController do
  use Beermusings.Web, :controller

  alias Beermusings.Brewery

  plug :scrub_params, "brewery" when action in [:create, :update]

  def index(conn, _params) do
    brewery = Repo.all(Brewery)
    render(conn, "index.html", brewery: brewery)
  end

  def new(conn, _params) do
    changeset = Brewery.changeset(%Brewery{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"brewery" => brewery_params}) do
    changeset = Brewery.changeset(%Brewery{}, brewery_params)

    case Repo.insert(changeset) do
      {:ok, _brewery} ->
        conn
        |> put_flash(:info, "Brewery created successfully.")
        |> redirect(to: brewery_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    brewery = Repo.get!(Brewery, id)
    render(conn, "show.html", brewery: brewery)
  end

  def edit(conn, %{"id" => id}) do
    brewery = Repo.get!(Brewery, id)
    changeset = Brewery.changeset(brewery)
    render(conn, "edit.html", brewery: brewery, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brewery" => brewery_params}) do
    brewery = Repo.get!(Brewery, id)
    changeset = Brewery.changeset(brewery, brewery_params)

    case Repo.update(changeset) do
      {:ok, brewery} ->
        conn
        |> put_flash(:info, "Brewery updated successfully.")
        |> redirect(to: brewery_path(conn, :show, brewery))
      {:error, changeset} ->
        render(conn, "edit.html", brewery: brewery, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brewery = Repo.get!(Brewery, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(brewery)

    conn
    |> put_flash(:info, "Brewery deleted successfully.")
    |> redirect(to: brewery_path(conn, :index))
  end
end
