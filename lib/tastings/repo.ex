defmodule Tastings.Repo do
  use Ecto.Repo,
    otp_app: :tastings,
    adapter: Ecto.Adapters.Postgres
end
