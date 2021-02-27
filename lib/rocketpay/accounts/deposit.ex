defmodule Rocketpay.Accounts.Deposit do
  alias Ecto.Multi
  alias Rocketpay.{Account, Repo}

  def call(%{"id" => id, "value" => value}) do
    Multi.new()
    |> Multi.run(:fetch_account, fn repo, _previous -> fetch_account(repo, id) end)
    |> Multi.run(:update_balance, fn repo, %{fetch_account: account} ->
      update_balance(repo, account, value)
    end)
    |> run_transaction()
  end

  defp fetch_account(repo, id) do
    case repo.get(Account, id) do
      nil -> {:error, "Account not found."}
      account -> {:ok, account}
    end
  end

  defp update_balance(repo, account, value) do
    account
    |> calculate_new_balance(value)
    |> update_account(account, repo)
  end

  defp calculate_new_balance(%Account{balance: balance}, value) do
    value
    |> Decimal.cast()
    |> handle_cast(balance)
  end

  defp handle_cast({:ok, casted_value}, balance), do: Decimal.add(casted_value, balance)
  defp handle_cast(:error, _reason), do: {:error, "Invalid deposit value."}

  defp update_account({:error, _reason} = error, _account, _repo), do: error

  defp update_account(new_balance, account, repo) do
    account
    |> Account.changeset(%{balance: new_balance})
    |> repo.update()
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do
      {:error, _operation, reason, _changes} -> {:error, reason}
      {:ok, %{update_balance: account}} -> {:ok, account}
    end
  end
end
