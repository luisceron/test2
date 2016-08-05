class Account < ActiveRecord::Base
  enum account_type: [:current_account, :saving_account, :cash_account]
  
  belongs_to :user
  has_many :transactions
  has_many :periods

  validates :account_type, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :user_id}

  after_create :create_first_period

  def to_s
    self.name
  end

  def create_first_period
    Period.create(account: self, year: Date.today.year, month: Date.today.month, start_balance: self.balance)
  end
end
