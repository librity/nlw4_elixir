defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  action_fallback RocketpayWeb.FallbackController

  def create(connection, params) do
    # Patter matcher with, returns error back to whatever called this function.
    # Otherwise it executes the block.
    with {:ok, %User{} = user} <- Rocketpay.create_user(params) do
      connection
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
