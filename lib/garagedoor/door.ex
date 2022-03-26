defmodule Garagedoor.Door do
  def init do
    Cachex.put!(:door, "users", [%{id: 1, name: "init", access_code: 19999, used_count: 0}])
    Cachex.put!(:door, "state", {true, Time.utc_now(), get_user("init", 19999)})
  end
  def state do
    {open?, time, user} = Cachex.get!(:door, "state")
    {open?, time, user.name}
  end
  def user_list(access_code) do
    if is_valid?(access_code) do
      Cachex.get!(:door, "users")
      |> Enum.map(fn(u) -> %{name: u.name, id: u.id, used_count: u.used_count} end)
    else
      "invalid access_code"
    end
  end
  def get_user(user_name, access_code) when is_binary(user_name) do
    user_list = Cachex.get!(:door, "users")
    |> Enum.reject(fn(u) -> u.name != user_name end)
    [user | tail] = user_list
    if tail == [] do
      user
    else
      user_list
    end
  end
  def get_user(%{id: id} = _user, access_code) do
    if is_valid?(access_code) do
      [user] = Cachex.get!(:door, "users")
      |> Enum.reject(fn(u) -> u.id != id end)
      user
    else
      "invalid access_code"
    end
  end
  def get_user(user_code, access_code) do
    get_user(user_code)
  end
  defp get_user(access_code) do
    if is_valid?(access_code) do
      [user | _] = Cachex.get!(:door, "users")
      |> Enum.reject(fn(u) -> u.access_code != access_code end)
      user
    else
      "invalid access_code"
    end
  end
  defp is_valid?(access_code) do
    user = Cachex.get!(:door, "users")
    |> Enum.filter(fn(u) -> u.access_code == access_code end)
    valid? = user != []
    if valid? do
      [user] = user
      user = Map.merge(user, %{used_count: user.used_count+1})
      user_list = Cachex.get!(:door, "users")
      |> Enum.reject(fn(u) -> u.access_code == access_code end)
      user_list = [user] ++ user_list
      Cachex.put!(:door, "users", user_list)
    end
    valid?
  end
  def use(access_code) do
    if is_valid?(access_code) do
      {is_open?, _time_used, _user} = state
      user = get_user(access_code)
      Cachex.put!(:door, "state", {!is_open?, Time.utc_now, user})
    else
      {:error, "invalid access_code"}
    end
  end
  defp generate_user(id, name) do
    %{id: id + 1, name: name, access_code: 10_000*(id+1)+:rand.uniform(9999), used_count: 0}
  end
  defp add_user(user) do
    user_list = Cachex.get!(:door, "users")
    user_list = [user] ++ user_list
    Cachex.put!(:door, "users", user_list)
    user
  end
  def create_user(%{name: name} = _user, access_code) do
    if is_valid?(access_code) do
      Cachex.get!(:door, "users")
      |> Enum.max_by(fn(u) -> u.id end)
      |> Map.fetch!(:id)
      |> generate_user(name)
      |> add_user
    else
      {:error, "invalid access_code"}
    end
  end
  def remove_user(user_code, access_code) do
    if is_valid?(access_code) do
      user_list = Cachex.get!(:door, "users")
      |> Enum.reject(fn(u) -> u.access_code == user_code end)

      Cachex.put!(:door, "users", user_list)
    else
      {:error, "invalid access_code"}
    end
  end
end
