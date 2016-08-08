class Period < ActiveRecord::Base
  belongs_to :account

  validates :year,  presence: true
  validates :month, presence: true
  validates :account_id, uniqueness: {scope: [:year, :month]}
end
