class Transaction < ActiveRecord::Base
  enum transaction_type: [:credit, :debit]

  belongs_to :user
  belongs_to :account
  belongs_to :category

  validates :account, presence: true
  validates :category, presence: true
  validates :transaction_type, presence: true
  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def to_s
    self.account.try(:name)    + " - " +
    self.transaction_type.to_s + " - " +
    self.category.try(:name)   + " - " +
    self.try(:description)
  end
end