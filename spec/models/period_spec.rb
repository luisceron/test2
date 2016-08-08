require 'rails_helper'

RSpec.describe Period, type: :model do
  context "must validate" do
    it "required attributes" do
      expect(subject).to validate_presence_of(:year)
      expect(subject).to validate_presence_of(:month)
    end

    it "unique attributes" do
      expect(subject).to validate_uniqueness_of(:account_id).case_insensitive.scoped_to([:year, :month])
    end
  end
end
