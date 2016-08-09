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

  def get_current_balance(current_user)
    set_color_for_amount(current_user.accounts.sum(:balance))
  end

  def get_previous_start_balance(periods)
    total_start_balance = 0 
    periods.each do |period|
      total_start_balance += period.start_balance
    end

    set_color_for_amount(total_start_balance)
  end

  def get_previous_end_balance(periods)
    total_end_balance = 0 
    periods.each do |period|
      total_end_balance += period.end_balance
    end

    set_color_for_amount(total_end_balance)
  end

  def set_color_for_amount(amount)
    if amount >= 0
      content_tag(:span, number_to_currency(amount), class: 'in-background')
    else
      content_tag(:span, number_to_currency(amount), class: 'out-background')
    end
  end

end
