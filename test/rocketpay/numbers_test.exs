defmodule Rocketpay.NumbersTest do
  use ExUnit.Case

  alias Rocketpay.Numbers

  describe "sum_from_file/1" do
    test "when csv file with $1 name exists, it returns the sum of its contents" do
      response = Numbers.sum_from_file("numbers")
      expected_response = {:ok, %{total: 37}}

      assert response == expected_response
    end

    test "when csv file with $1 name doesn't exists, it returns an error message" do
      response = Numbers.sum_from_file("snuffleupagus")
      expected_response = {:error, %{message: "Invalid file!"}}

      assert response == expected_response
    end
  end
end
