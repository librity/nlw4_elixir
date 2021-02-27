defmodule RocketpayWeb.WelcomeController do
  use RocketpayWeb, :controller

  alias Rocketpay.Numbers

  def index(connection, _params) do
    connection |> text("Welcome to RocketPay API!")
  end

  def total(connection, %{"filename" => filename}) do
    filename
    |> Numbers.sum_from_file()
    |> handle_response(connection)
  end

  defp handle_response({:ok, %{total: total}}, connection) do
    connection
    |> put_status(:ok)
    # Use inspects for debugging
    # |> IO.inspect()
    |> json(%{message: "Here is your number: #{total}"})
  end

  defp handle_response({:error, reason}, connection) do
    connection
    |> put_status(:bad_request)
    # |> IO.inspect()
    |> json(reason)
  end
end
