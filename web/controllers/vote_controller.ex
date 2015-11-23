defmodule Beermusings.VoteController do
  use Beermusings.Web, :controller

  alias Beermusings.Vote
  alias Beermusings.Post

  plug :scrub_params, "vote" when action in [:create, :update]

  def create(conn, %{"vote" => vote_params, "post_id" => post_id}) do
    post = Repo.get(Post, post_id)
    changeset = Ecto.Model.build(post, :post)
    |> Vote.changeset(vote_params)

    case Repo.insert(changeset) do
      {:ok, _vote} ->
        conn
        |> put_flash(:info, "Vote created successfully.")
        |> redirect(to: post_path(conn, :show, post_id))
      {:error, changeset} ->
        redirect(conn, to: post_path(conn, :index))
    end
  end

  def vote(conn, %{"post_id": post_id, "weight": weight}) do
    post = Repo.get(Post, post_id)
    changeset = Ecto.Model.build(post, :votes)
    |> Vote.changeset(%{weight: weight})

    case Repo.insert(changeset) do
      {:ok, _vote} ->
        conn
        |> put_flash(:info, "Upvoted successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to upvote.")
        |> redirect(to: post_path(conn, :index))
    end
  end

  def upvote(conn, %{"post_id" => post_id}) do
    vote(conn, %{post_id: post_id, weight: 1})
  end

  def downvote(conn, %{"post_id" => post_id}) do
    vote(conn, %{post_id: post_id, weight: -1})
  end

  def show(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)
    render(conn, "show.html", vote: vote)
  end

  def edit(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)
    changeset = Vote.changeset(vote)
    render(conn, "edit.html", vote: vote, changeset: changeset)
  end

  def update(conn, %{"id" => id, "vote" => vote_params}) do
    vote = Repo.get!(Vote, id)
    |> Repo.preload(:post)
    changeset = Vote.changeset(vote, vote_params)

    case Repo.update(changeset) do
      {:ok, vote} ->
        conn
        |> put_flash(:info, "Vote updated successfully.")
        |> redirect(to: post_path(conn, :show, vote.post_id))
      {:error, changeset} ->
        #render(conn, "edit.html", vote: vote, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    vote = Repo.get!(Vote, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(vote)

    conn
    |> put_flash(:info, "Vote deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
