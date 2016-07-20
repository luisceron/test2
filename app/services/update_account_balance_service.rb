class UpdateAccountBalanceService

  attr_accessor :transaction, :account, :transaction_type, :amount

  def initialize(transaction)
    @transaction      = transaction
    @account          = transaction.account
    @transaction_type = transaction.transaction_type
    @amount           = transaction.amount
  end

  def add
    if transaction_type.to_sym == :in
      account.balance += amount
    elsif transaction_type.to_sym == :out
      account.balance -= amount
    end

    account.save
  end

  def update
    if transaction.transaction_type_was.to_sym == :in
      account.balance -= transaction.amount_was
    elsif transaction.transaction_type_was.to_sym == :out
      account.balance += transaction.amount_was
    end

    add
  end

  def subtract
    if transaction_type.to_sym == :in
      account.balance -= amount
    elsif transaction_type.to_sym == :out
      account.balance += amount
    end

    account.save
  end
end
