defmodule Beermusings.CommentController do
  use Beermusings.Web, :controller

  alias Beermusings.Post
  alias Beermusings.Comment

  plug :scrub_params, "comment" when action in [:create, :update]

  def index(conn, _params) do
    comments = Repo.all(Comment)
    render(conn, "index.html", comments: comments)
  end

  def new(conn, %{"post_id" => post_id}) do
    {post_id_int, _} = Integer.parse(post_id)
    invalidPostId = true
    if is_integer(post_id_int) do
      post = Repo.get(Post, post_id)
      unless is_nil(post) do
        invalidPostId = false
        changeset = Comment.changeset(%Comment{})
        render(conn, "new.html", %{changeset: changeset, post_id: post_id, post: post})
      end
    end
    if invalidPostId do
      conn
      |> put_flash(:error, "Unknown post.")
      |> redirect(to: "/")
    end
  end

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    post = Repo.get(Post, post_id)
    changeset = Ecto.Model.build(post, :comments)
      |> Comment.changeset(comment_params)

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: post_path(conn, post_id, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: comment_path(conn, :show, comment))
      {:error, changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: comment_path(conn, :index))
  end
end
