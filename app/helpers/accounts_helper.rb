module AccountsHelper
  def account_form_path account
    if account.new_record?
      user_accounts_path(account.user)
    else
      account_path(account)
    end
  end

  def user_accounts_for_select user
    user.accounts.collect do |account|
      [account.name, account.id]
    end
  end
end
