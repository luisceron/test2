module TransactionsHelper
  def transaction_form_path transaction
    if transaction.new_record?
      user_transactions_path transaction.user
    else
      transaction_path transaction
    end
  end
end
