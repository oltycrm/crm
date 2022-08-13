defmodule CrmWeb.CardView do
  use CrmWeb, :view

  def get_deal_by_transaction_id(transaction_id) do
    transaction = Crm.Transactions.get_transaction!(transaction_id)
    Crm.Deals.get_deal!(transaction.deal_id)
  end
end
