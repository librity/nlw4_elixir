defmodule Rocketpay.Accounts.Operation do
  alias Ecto.Multi
  alias Rocketpay.Account

  def call(%{"id" => id, "value" => value}, operation) do
    fetch_account_operation_name = build_fetch_account_operation_name(operation)

    Multi.new()
    |> Multi.run(
      fetch_account_operation_name,
      fn repo, _previous -> fetch_account(repo, id) end
    )
    |> Multi.run(operation, fn repo, fetch_result ->
      account = Map.get(fetch_result, fetch_account_operation_name)

      update_balance(repo, account, value, operation)
    end)
  end

  defp fetch_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found."}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value, operation) do
    account
    |> calculate_new_balance(value, operation)
    |> update_account(account, repo)
  end

  defp calculate_new_balance(%Account{balance: balance}, value, operation) do
    value
    |> Decimal.cast()
    |> validate_greater_than_zero()
    |> handle_cast(balance, operation)
  end

  defp validate_greater_than_zero({:ok, casted_value}) do
    case Decimal.compare(casted_value, 0) do
      :lt -> :error
      :eq -> :error
      :gt -> {:ok, casted_value}
    end
  end

  defp validate_greater_than_zero(:error), do: :error

  defp handle_cast({:ok, valid_value}, balance, :deposit), do: Decimal.add(balance, valid_value)
  defp handle_cast({:ok, valid_value}, balance, :withdraw), do: Decimal.sub(balance, valid_value)

  defp handle_cast(:error, _balance, :deposit), do: {:error, "Invalid deposit value."}
  defp handle_cast(:error, _balance, :withdraw), do: {:error, "Invalid withdraw value."}

  defp update_account({:error, _reason} = error, _account, _repo), do: error

  defp update_account(new_balance, account, repo) do
    account
    |> Account.changeset(%{balance: new_balance})
    |> repo.update()
  end

  defp build_fetch_account_operation_name(operation),
    do: "fetch_#{operation}_account" |> String.to_atom()
end
