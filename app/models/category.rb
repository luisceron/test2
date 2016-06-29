class Category < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :user_id}

  def to_s
    self.name
  end
end
