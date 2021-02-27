defmodule Rocketpay.Numbers do
  def sum_from_file(filename) do
    "#{filename}.csv"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, file_contents}) do
    total =
      file_contents
      |> String.split(",")
      # |> Enum.map(fn number_string -> String.to_integer(number_string) end)
      |> Stream.map(fn number_string -> String.to_integer(number_string) end)
      |> Enum.sum()

    {:ok, %{total: total}}
  end

  defp handle_file({:error, _reason}), do: {:error, %{message: "Invalid file!"}}
end
