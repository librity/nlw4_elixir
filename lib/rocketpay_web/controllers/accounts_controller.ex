defmodule RocketpayWeb.AccountsController do
  use RocketpayWeb, :controller

  alias Rocketpay.Account
  alias Rocketpay.Accounts.Transactions.Response, as: TransactionResponse

  action_fallback RocketpayWeb.FallbackController

  def deposit(connection, params) do
    with {:ok, %Account{} = account} <- Rocketpay.deposit(params) do
      connection
      |> put_status(:ok)
      |> render("deposit.json", account: account)
    end
  end

  def withdraw(connection, params) do
    with {:ok, %Account{} = account} <- Rocketpay.withdraw(params) do
      connection
      |> put_status(:ok)
      |> render("withdraw.json", account: account)
    end
  end

  def transaction(connection, params) do
    # Unlike NodeJS that runs as a single process, we don't have to constantly
    # deal with async/await calls: Every request in Phoenix runs as a separate
    # process because BEAM is optimized for process-creation.
    # We can create concurrent tasks (process) with the module:
    task = Task.async(fn -> Rocketpay.transact(params) end)

    # CONCURRENT CODE
    for i <- 0..200,
        i > 0,
        do:
          IO.puts(
            "[#{DateTime.utc_now()}] I'm running concurrently wih the `Rocketpay.transact(params)`!"
          )

    result = Task.await(task)
    # This is completely unecessary in this situation, but if we wanted to run
    # the transaction and do something unrelated at the same time, this would be
    # a valid optimization

    # We can also use Task.start if we dont't care about the return of the process:
    # Task.start(fn -> Rocketpay.transact(params) end)

    with {:ok, %TransactionResponse{} = transaction} <- result do
      connection
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
