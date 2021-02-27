defmodule RocketpayWeb.AccountsView do
  alias Rocketpay.{Account}

  def render("update.json", %{
        account: %Account{
          balance: balance,
          id: id
        }
      }) do
    %{
      message: "Value deposited successfully.",
      account: %{
        balance: balance,
        id: id
      }
    }
  end
end
