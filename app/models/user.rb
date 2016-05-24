class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :lockable, :timeoutable

  attr_accessor :typed_email

  before_validation :set_name, on: :create
  validates :name, presence: true

  # before_create :create_user

  private
    def set_name
      self.name = self.email.split("@").first if self.email
    end

    # def create_user
    #   generated_password = Devise.friendly_token.first(8)
    #   self.password = generated_password
      # user = User.create!(:email => email, :password => generated_password)

    #   RegistrationMailer.welcome(user, generated_password).deliver
    # end
end
