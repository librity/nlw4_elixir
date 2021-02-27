defmodule Rocketpay.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias Rocketpay.Account

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:name, :nickname, :email, :password, :age]

  schema "users" do
    field :name, :string
    field :nickname, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :age, :integer

    has_one :account, Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> unique_constraint([:email])
    |> unique_constraint([:nickname])
    |> add_password_hash()
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp add_password_hash(changeset), do: changeset
end
