defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.{User, Repo}
  alias Rocketpay.Users.Create

  describe("call/1") do
    test "when all params are valid, returns a created user" do
      params = %{
        name: "Luisito",
        nickname: "luisito",
        email: "luisito@gmail.com",
        password: "123456",
        age: 42
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{
               id: ^user_id,
               name: "Luisito",
               nickname: "luisito",
               email: "luisito@gmail.com",
               age: 42
             } = user
    end

    test "when age and password aren't valid, returns an error" do
      params = %{
        name: "Luisito",
        nickname: "luisito",
        email: "luisito@gmail.com",
        password: "123",
        age: 17
      }

      {:error, user_changeset} = Create.call(params)

      expected_errors = %{
        age: ["must be greater than or equal to 18"],
        password: ["should be at least 6 character(s)"]
      }

      assert expected_errors == errors_on(user_changeset)
    end
  end
end
