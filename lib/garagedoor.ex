defmodule Garagedoor do
  alias Garagedoor.Door
  def state do
    {is_open?, time_since, user} = Door.state
    if is_open? do
      {"open", Time.diff(Time.utc_now, time_since, :second), user}
    else
      {"closed", Time.diff(Time.utc_now, time_since, :second), user}
    end
  end
  def close(access_code) do
    {is_open?, _, _} = Door.state
    if is_open? do
      Door.use(access_code)
    else
      "Door already closed"
    end
  end
  def open(access_code) do
    {is_open?, _, _} = Door.state
    if is_open? do
      "Door already open"
    else
      Door.use(access_code)
    end
  end
  def new_code(%{name: user_name}, access_code) do
    Door.create_user(%{name: user_name}, access_code)
  end
  def new_code(user_name, access_code) do
    Door.create_user(%{name: user_name}, access_code)
  end
  def remove_code(user_name, access_code) when is_binary(user_name) do
    remove_code(%{name: user_name}, access_code)
  end
  def remove_code(%{name: user_name}, access_code) do
    user = Door.get_user(user_name, access_code)
    if is_map(user) do
      remove_code(user.access_code, access_code)
    else
      {"too many users with that name, choose an access code", user}
    end
  end
  def remove_code(%{id: _id} = user_map, access_code) do
    Door.get_user(user_map, access_code)
    |> Map.fetch!(:access_code)
    |> remove_code(access_code)
  end
  def remove_code(user_code, access_code) do
    Door.remove_user(user_code, access_code)
  end
  def used_count(access_code) do
    Door.get_user(access_code, access_code)
    |> Map.fetch!(:used_count)
  end
  def used_count(user_name, access_code) when is_binary(user_name) do
    user = Door.get_user(user_name, access_code)
    if is_map(user) do
      user.used_count
    else
      Enum.map(user, fn(u) -> %{id: u.id, count: u.used_count} end)
    end
  end
  def get_users(access_code) do
    Door.user_list(access_code)
  end
end
