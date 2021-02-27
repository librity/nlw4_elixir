defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias Rocketpay.{Account, User}
  alias Rocketpay.Users.Create

  test "renders create.json" do
    user_params = %{
      name: "Luisito",
      nickname: "luisito",
      email: "luisito@gmail.com",
      password: "123456",
      age: 42
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} = Create.call(user_params)

    renderd_view = render(RocketpayWeb.UsersView, "create.json", user: user)

    expected_view = %{
      message: "User created.",
      user: %{
        id: user_id,
        name: "Luisito",
        nickname: "luisito",
        account: %{
          id: account_id,
          balance: Decimal.new("0.00")
        }
      }
    }

    assert renderd_view == expected_view
  end
end
