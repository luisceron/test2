require 'rails_helper'

RSpec.describe Account, type: :model do
  it "must validate required attributes" do
    expect(subject).to validate_presence_of(:account_type)
    expect(subject).to validate_presence_of(:name)
  end

  it "must validate unique attributes" do
    expect(subject).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id)
  end
end
