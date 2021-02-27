defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{User, Account}

  describe "deposit/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Luisito",
        nickname: "luisito",
        email: "luisito@gmail.com",
        password: "123456",
        age: 42
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(user_params)
      conn = put_req_header(conn, "authorization", "Basic Zm9vYmFyOjEyMzQ1Ng==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when user is authorized and all params are valid, deposits the expected value", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "42.42"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, request_params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "42.42", "id" => _id},
               "message" => "Value deposited successfully."
             } = response
    end

    test "when value isn't a valid Decimal, returns an error", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "foobar"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, request_params))
        |> json_response(:bad_request)

      invalid_value_response = %{"message" => "Invalid deposit value."}

      assert response == invalid_value_response
    end

    test "when value is zero, returns an error", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "00.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, request_params))
        |> json_response(:bad_request)

      invalid_value_response = %{"message" => "Invalid deposit value."}

      assert response == invalid_value_response
    end

    test "when value is negative, returns an error", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "-50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, request_params))
        |> json_response(:bad_request)

      invalid_value_response = %{"message" => "Invalid deposit value."}

      assert response == invalid_value_response
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Luisito",
        nickname: "luisito",
        email: "luisito@gmail.com",
        password: "123456",
        age: 42
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(user_params)
      deposit_params = %{"id" => account_id, "value" => "420.42"}
      Rocketpay.deposit(deposit_params)

      conn = put_req_header(conn, "authorization", "Basic Zm9vYmFyOjEyMzQ1Ng==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when user is authorized and all params are valid, withdraws the expected value", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, request_params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "370.42", "id" => _id},
               "message" => "Value withdrawn successfully."
             } = response
    end

    test "when value isn't a valid Decimal, returns an error", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "foobar"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, request_params))
        |> json_response(:bad_request)

      invalid_value_response = %{"message" => "Invalid withdraw value."}

      assert response == invalid_value_response
    end

    test "when value is zero, returns an error", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "00.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, request_params))
        |> json_response(:bad_request)

      invalid_value_response = %{"message" => "Invalid withdraw value."}

      assert response == invalid_value_response
    end

    test "when value is negative, returns an error", %{
      conn: conn,
      account_id: account_id
    } do
      request_params = %{"value" => "-50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, request_params))
        |> json_response(:bad_request)

      invalid_value_response = %{"message" => "Invalid withdraw value."}

      assert response == invalid_value_response
    end
  end
end
