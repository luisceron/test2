module AccountsHelper
  def account_form_path account
    if account.new_record?
      user_accounts_path(account.user)
    else
      account_path(account)
    end
  end
end
