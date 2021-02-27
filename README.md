# Next Level Week - RocketPay

A payments backend using Elixir, Phoenix and Ecto.

## Endpoints

Built-in:

- `GET` http://localhost:4000/dashboard/home

`WelocomeController`:

- `GET` http://localhost:4000/api/
- `GET` http://localhost:4000/api/total/:filename

`UsersController`

- `POST` http://localhost:4000/api/users

`AccountsController`

- `POST` http://localhost:4000/api/accounts/:id/deposit
- `POST` http://localhost:4000/api/accounts/:id/withdraw
- `POST` http://localhost:4000/api/accounts/transaction

## External Docs

- https://elixir-lang.org/docs.html
- https://elixir-lang.org/getting-started/basic-types.html
- https://elixir-lang.org/getting-started/debugging.html

- https://hexdocs.pm/elixir/Kernel.html
- https://hexdocs.pm/elixir/master/Task.html
- https://hexdocs.pm/iex/IEx.Helpers.html
- https://hexdocs.pm/phoenix/Phoenix.html
- https://hexdocs.pm/ecto/Ecto.html
- https://hexdocs.pm/decimal/readme.html
- https://hexdocs.pm/excoveralls/readme.html
- https://github.com/rrrene/credo/

## Random Tutorials and Questions

- https://www.tutorialspoint.com/elixir/elixir_lists_and_tuples.htm
- https://www.frankelydiaz.com/blog/i-learned-today-elixir-pipe-operator-calling-a-function-with-more-than-1-parameter
- https://stackoverflow.com/questions/66379509/elixir-decimal-cast-and-dont-allow-negative-numbers
- https://stackoverflow.com/questions/31990134/how-to-convert-map-keys-from-strings-to-atoms-in-elixir
- https://stackoverflow.com/questions/28594646/getting-the-current-date-and-or-time-in-elixir
- https://stackoverflow.com/questions/47818241/concise-way-to-run-code-0-to-n-times-in-elixir

## Postgres

Create a new docker container with:

```bash
$ docker run --name postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres
```

## Bash Commands

```bash
# Install Phoenix
$ mix archive.install hex phx_new 1.5.7

# Create a Phoenix API (like rails new)
$ mix phx.new rocketpay --no-webpack --no-html

# Setup Ecto (database wrapper and query generator) and check database connection (like rails db:setup)
$ mix ecto.setup

# Install dependencies (like bundle install)
$ mix deps.get

# Create config file for credo (linter, like rubocop)
$ mix credo gen.config

# Run credo
$ mix credo

# Start the server (like rails s)
$ mix phx.server

# Interactive Elixir console (like irb)
$ iex

# Phoenix app console (like rails c)
$ iex -S mix

# Runs tests (like bundle exec rspec)
$ mix test

# Create a migration
$ mix ecto.gen.migration create_user_table

# Migrate database
$ mix ecto.migrate

# Drop database
$ mix ecto.drop

# Create database
$ mix ecto.create

# Generate code coverage report
$ mix test --cover

# Generate an HTML code coverage report (just like the coveralls gem)
$ mix coveralls.html
```

## Elixir Commands

```elixir
# Calling a function from a module
> Rocketpay.Numbers.sum_from_file("numbers")
{:ok, "1,2,3,4,8,9,10"}
# ^^^ In Elixir tuples are a arrays on a continous block of memory (faster)
> Rocketpay.Numbers.sum_from_file("snuffleupagus")
{:error, :enoent}

# = is a pattern matcher, not an attributor
> {:ok, file} = File.read("numbers.csv")
{:ok, "1,2,3,4,8,9,10"}
> file
"1,2,3,4,8,9,10"
> {:ok, file} = File.read("snuffleupagus.csv")
** (MatchError) no match of right hand side value: {:error, :enoent}
> [a,b,c,d] = [1,2,3,4]
[1, 2, 3, 4]
> [a,b] = [1,2,3,4]
** (MatchError) no match of right hand side value: [1, 2, 3, 4]

> recompile
Compiling 1 file (.ex)
:ok
> Rocketpay.Numbers.sum_from_file("numbers")
"1,2,3,4,8,9,10"
> Rocketpay.Numbers.sum_from_file("snuffleupagus")
{:error, "Invalid file!"}

# Pipe operator (like bash |)
> "numbers.csv" |> File.read()
{:ok, "1,2,3,4,8,9,10"}
> "snuffleupagus.csv" |> File.read()
{:error, :enoent}

# h before a function to read the documentation
> h String.split
(...)
# Tab-complete works the same as bash
> String.\t
(...)

> list = String.split("1,2,3,4,8,9,10", ",")
["1", "2", "3", "4", "8", "9", "10"]
# Immutability == Security
> number_list = Enum.map(list, fn number_string -> String.to_integer(number_string) end)
[1, 2, 3, 4, 8, 9, 10]
> total = Enum.sum(number_list)
37

# Enum isn't lazy
> "1,2,3,4,8,9,10" |>
    String.split(",") |>
    Enum.map(fn number_string -> String.to_integer(number_string) end) |>
    Enum.sum()
37
# Stream is lazy
> "1,2,3,4,8,9,10" |>
    String.split(",") |>
    Stream.map(fn number_string -> String.to_integer(number_string) end) |>
    Enum.sum()
# We should use Stream between enums: the compiler then knows to do it all at
# once and optimizes it.

> recompile
> Rocketpay.Numbers.sum_from_file("numbers")
37

# Maps (hashes in ruby)
> my_map = %{result: :ok, total: 37}
> my_map[:result]
:ok
> my_map.total
37

> alias Rocketpay.Numbers
> Numbers.sum_from_file("numbers")
{:ok, %{total: 37}}
> alias Rocketpay.Numbers, as: Snuffleupagus
> Snuffleupagus.sum_from_file("numbers")
{:ok, %{total: 37}}

> %{filename: whatever} = %{filename: "numbers", value: 7}
> whatever
"numbers"

# Similiar to "  RaFaEl  ".strip.downcase
> "  RaFaEl  " |> String.trim() |> String.downcase()
"rafael"

> Ecto.UUID.generate
"04980ee4-6b82-4523-966f-f4600a2631e9"

> :this_is_an_atom
> :this_is_not_a_symbol

> Bcrypt.add_hash("dasda")
%{password_hash: "$2b$12$SgkYtcvmDSlkOv86tsCxVOp8e9SAShSuqd1fEmYhMbOrtsdVNTwum"}

# Like Model.attributes
> %Rocketpay.User{}
> params = %{name: "Luisito", nickname: "luisito", email: "luisito@gmail.com",
                password: "dsadsadsadas ad", age: 87}
# Like Model.new({attributes: attr})
> Rocketpay.User.changeset(params)
# Like Model.create({attributes: attr})
> Rocketpay.Users.Create.call(params)
# With delegate
> Rocketpay.create_user(params)

> Rocketpay.Repo.all(Rocketpay.User)
> Rocketpay.Repo.all(Rocketpay.User) |> Rocketpay.Repo.preload(:account)

> Base.encode64("foobar:123456")
"Zm9vYmFyOjEyMzQ1Ng=="
```
