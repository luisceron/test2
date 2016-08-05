class Transaction < ActiveRecord::Base
  enum transaction_type: [:in, :out]

  belongs_to :user
  belongs_to :account
  belongs_to :category

  validates :account, presence: true
  validates :category, presence: true
  validates :transaction_type, presence: true
  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :scope_in,  -> {where(transaction_type: 0)}
  scope :scope_out, -> {where(transaction_type: 1)}
  scope :current_month_scope, -> {where('extract(year from date) = ? AND extract(month from date) = ?', Date.today.year, Date.today.month)}
  scope :by_year,  -> (year) {where('extract(year from date) = ?', year)}
  scope :by_month, -> (month){where('extract(month from date) = ?', month && month.length >= 2 ? JSON.parse(month) : month)}

  after_initialize :set_date
  after_create     :add_to_account_balance
  after_update     :update_account_balance
  after_destroy    :subtract_to_account_balance

  def to_s
    I18n.t(self.transaction_type.to_sym, scope: "activerecord.attributes.transaction.transaction_types") 
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:by_year, :by_month]
  end

  def set_date
    self.date ||= Date.today
  end

  def add_to_account_balance
    UpdateAccountBalanceService.new(self).add
  end

  def update_account_balance
    UpdateAccountBalanceService.new(self).update
  end

  def subtract_to_account_balance
    UpdateAccountBalanceService.new(self).subtract
  end

end
