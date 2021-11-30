# Homer

This is my [work](https://github.com/maxime-burriez/homer) (ref. [Maxime Burriez](https://github.com/maxime-burriez)) in response to the [Ulysse Technical Test](./docs/elixir_technical_test.md).

## Install and start

To start your Phoenix server:

  * Copy `.env.example` file into a new `.env` file
  * Set `DUFFEL_TOKEN` in `.env`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests

To run tests, call : `mix test`.

## Static code analysis (credo)

To run a static code analysis : `mix credo`.

Moreover, the last warnings have been resolved in [this commit](https://github.com/maxime-burriez/homer/pull/9/commits/a0646350cf04f35c79616f7be49cc63f239845b8).

## Steps

### Step 1 :

```
1. Create a new Phoenix LiveView project named `homer` :
`mix phx.new homer --live`
```

[The first commit.](https://github.com/maxime-burriez/homer/commit/ee9a3ce752c9f7324af7fb1ce8c38e6aa4e6073f)

### Step 2

```
2. Use the following command to create the `Search` context and the `OfferRequest` schema : 
`mix phx.gen.live Search OfferRequest offer_requests origin:string destination:string departure_date:date sort_by:string allowed_airlines:array:string`

Replace the ...
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/1/files)

### Step 3

```
3. Modify the generated code to ensure that the following specs are respected :
- We can create an offer request by providing these fields (and only these one): origin, destination and a departure date.
- Origin and destination are airport iata code.
- All airlines are allowed by default.
- Offers are sorted by price by default (ascending order).
- We can only update the list of allowed airlines and the sort order.
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/2/files)

### Step 4

```
4. Use the following command to create the `Offer` schema : `mix phx.gen.schema Search.Offer offers origin:string destination:string departing_at:naive_datetime arriving_at:naive_datetime segments_count:integer total_amount:decimal total_duration:integer`

PS: `total_duration` is in minutes
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/3/files)

### Step 5

```
5. Create the `Homer.Search.Duffel` module that must implement the following behaviour...
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/4/files)

### Step 6

```
6. Create the `Homer.Search.Server` module which use a [GenServer](https://hexdocs.pm/elixir/1.12/GenServer.html) and that must implement the following behaviour...
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/5/files)

### Step 7

```
7. Modify the `Homer.Search.Server` module to stop the `GenServer` after 15 minutes of inactivity.
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/6/files)

### Step 8

```
8. Modify the `Homer.Search` to implement to following behaviour. You can add as many functions as you want...
```

[The corresponding primary PR.](https://github.com/maxime-burriez/homer/pull/7/files)

[The corresponding secondary PR.](https://github.com/maxime-burriez/homer/pull/8/files)

### Step 9

```
9. Update `/offer_requests/:id` to display the top 10 orders.
```

[The corresponding PR.](https://github.com/maxime-burriez/homer/pull/9/files)

## Questions

### Question 1

> Given than in production we can have more than 5000 offers for one offer request. What persistence strategy do you suggest for offers ? Explain why.

Each `Offer` has a `belongs_to` relation with an `OfferRequest`.

In order to optimize the database architecture, I would use the [Ecto multi-tenancy with query prefixes](https://hexdocs.pm/ecto/multi-tenancy-with-query-prefixes.html) to run queries on a specific prefix (ie. _schema_ for postgreSQL).

Suggested distribution strategy : a given prefix will group all the `OfferRequest` having the same `departure_date`. Each `Offer` for each `OfferRequest` must also be associated with the prefix relating to their `OfferRequest`.

In this way, the `Offer`'s will be well distributed in the database.

### Question 2

> We now want to deploy the app we just created on multiple servers that are connected together using distributed erlang. Which parts of the code will require an update and why ?

The parts of the code will require an update are :

- [`mix.exs`](./mix.exs) :

  Add [libcluster](https://github.com/bitwalker/libcluster) dependency to provide a mechanism for automatically forming clusters of Erlang nodes.

- [`config.exs`](./config/config.exs), [`dev.exs`](./config/dev.exs) and [`prod.exs`](./config/prod.exs) :

  Provide a different port for each started Phoenix's server instance.

- [`Homer.Application`](./lib/homer/application.ex) :

  Add `Cluster.Supervisor` configuration.

- [`Homer.Search.Server`](./lib/homer/search/server.ex) :

  Handle all messages from clusters of Erlang nodes.

## About me

  * Github profile: https://github.com/maxime-burriez
  * Linkedin profile: https://www.linkedin.com/in/maxime-burriez/

Thank you !
