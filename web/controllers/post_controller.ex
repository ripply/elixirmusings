defmodule Beermusings.PostController do
  use Beermusings.Web, :controller

  alias Beermusings.Post
  alias Beermusings.Beer

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    posts = Repo.all(Post)
    |> Repo.preload(:comments)
    |> Repo.preload(:beer)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, %{"beer_id" => beer_id}) do
    changeset = Repo.get(Beer, beer_id)
    |> Ecto.Model.build(:posts)
    |> Post.changeset()
    render(conn, "new.html", changeset: changeset, beer_id: beer_id)
  end

  def create(conn, %{"post" => post_params, "beer_id" => beer_id}) do
    beer = Repo.get(Beer, beer_id)
    changeset = Ecto.Model.build(beer, :posts)
    |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    |> Repo.preload(:comments)
    |> Repo.preload(:beer)

    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
