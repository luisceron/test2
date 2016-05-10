class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :lockable, :timeoutable

  before_validation :set_name, on: :create
  validates :name, presence: true

  private
    def set_name
      self.name = self.email.split("@").first if self.email
    end
end
