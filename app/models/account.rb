class Account < ActiveRecord::Base
  enum account_type: [:current_account, :saving_account, :cash_account]
  
  belongs_to :user

  validates :account_type, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :user_id}
end
