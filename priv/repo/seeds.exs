# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
# Crm.Repo.insert!(%Crm.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# for n <- 1..100 do
# Crm.Repo.insert!(%Crm.Products.Product{ name: "name" <> Integer.to_string(n), period: n, price: n + 1.1})
# end

for n <- 1..100 do
  Crm.Repo.insert!(%Crm.Clients.Client{
    name: "Client_#{n}",
    avito: "av#{n * 2}",
    tg: "tg#{n * 3}",
    wa: "wa#{n * 4}",
    phone: "#{79_569_994_565 + n * 55}"
  })
end

# for client <- Crm.Repo.all(Crm.Clients.Client) do
#     Crm.Repo.insert! %Crm.SonyAccounts.SonyAccount{
#         email: "#{client.name}@zalupa",
#         password: "pass#{client.avito}",
#         client_id: client.id
#     }
# end

# for client <- Crm.Repo.all(Crm.Clients.Client) do
#   Crm.Repo.insert!(%Crm.Deals.Deal{
#     amount: client.id + 1.1,
#     status:
#       1..3
#       |> Enum.random()
#       |> then(fn n ->
#         case n do
#           1 -> :lead
#           2 -> :work
#           3 -> :closed
#         end
#       end),
#     client_id: client.id,
#     product_id: 1..102 |> Enum.random(),
#     user_id: 1..4 |> Enum.random(),
#     rubles:
#       500..5000
#       |> Enum.random()
#       |> Kernel.+(77.7)
#   })
# end

# Crm.Repo.insert!(%Crm.Cards.Card{ name: "", card_number: "", code: nil, balance: nil, status: ""})
