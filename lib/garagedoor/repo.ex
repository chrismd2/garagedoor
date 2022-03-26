defmodule Garagedoor.Repo do
  use Ecto.Repo,
    otp_app: :garagedoor,
    adapter: Ecto.Adapters.Postgres
end
