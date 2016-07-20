class TotalizerTransactionsService

  attr_reader :transactions, :transactions_in, :transactions_out

  def initialize(transactions)
    @transactions     = transactions
    @transactions_in  = @transactions.scope_in
    @transactions_out = @transactions.scope_out
  end

  def totalize_transactions_in
    transactions_in.sum(:amount)
  end

  def totalize_transactions_out
    transactions_out.sum(:amount)
  end
end
