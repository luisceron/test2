module TransactionsHelper
  def transaction_form_path transaction
    if transaction.new_record?
      user_transactions_path transaction.user
    else
      transaction_path transaction
    end
  end

  def years_for_select
    2016.upto(Date.today.year).to_a
  end

  def months_for_select
    months = t('date.month_names').drop(1)

    months.enum_for(:each_with_index).collect do |month, index| 
      [month, index + 1]
    end
  end
end
