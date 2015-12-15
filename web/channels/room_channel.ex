defmodule Beermusings.RoomChannel do
  use Beermusings.Web, :channel

  def start_link() do
    case Agent.start_link(fn -> HashDict.new end, name: __MODULE__) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def modify_room_count(room_id, by) do
    Agent.get_and_update(__MODULE__, fn dict ->
      case Dict.fetch(dict, room_id) do
        {:ok, room_dict} ->
          case Dict.fetch(room_dict, :count) do
            {:id , count} ->
              new_count = count + by
              {new_count, Dict.put(dict, room_id, Dict.put(room_dict, :countj, new_count))}
            :error ->
              {by, Dict.put(room_dict, room_id, HashDict.new |> Dict.put(:count, by))}
          end
        :error ->
          {0, Dict.put(dict, room_id, by)}
      end
    end)
  end

  def get_room_count(room_id) do
    Agent.get(__MODULE__, fn dict ->
      case Dict.fetch(dict, room_id) do
        {:ok, room_dict} ->
          case Dict.fetch(room_dict, :count) do
            {:ok, count} ->
              count
            :error ->
              0
          end
        :error ->
          0
      end
    end)
  end

  def increment(room_id) do
    IO.puts("INCREMENT")
    modify_room_count(room_id, 1)
  end

  def decrement(room_id) do
    IO.puts("DECREMENT")
    modify_room_count(room_id, -1)
  end

  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      increment("rooms:lobby")
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("rooms:" <> room_id, _params, socket) do
    broadcast socket, "join", %{"body" => increment("rooms:#{room_id}")}
    {:ok, socket}
  end

  def terminate(reason, socket) do
    IO.puts("TERMINATE!!1")
    broadcast socket, "leave", %{"body" => decrement(socket.topic)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_in("new_msg", %{"body" => body}, socket) do
    IO.inspect(socket)
    broadcast socket, "new_msg", %{"body" => body}
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
