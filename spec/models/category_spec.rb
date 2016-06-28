require 'rails_helper'

RSpec.describe Category, type: :model do
  context "must validate" do
    it "required attributes" do
      expect(subject).to validate_presence_of(:name)
    end

    it "unique attributes" do
      expect(subject).to validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id)
    end
  end
end
