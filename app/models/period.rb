class Period < ActiveRecord::Base
  belongs_to :account

  validates :year,  presence: true, uniqueness: {scope: :account}
  validates :month, presence: true, uniqueness: {scope: :account}
end
