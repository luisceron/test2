require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context "must validate" do
    it "required attributes" do
      expect(subject).to validate_presence_of(:account)
      expect(subject).to validate_presence_of(:category)
      expect(subject).to validate_presence_of(:transaction_type)
      expect(subject).to validate_presence_of(:date)
      expect(subject).to validate_presence_of(:amount)
    end

    it "numericality" do
      expect(subject).to     validate_numericality_of(:amount)
      expect(subject).to     allow_value(0)   .for(:amount)
      expect(subject).to     allow_value(1)   .for(:amount)
      expect(subject).to     allow_value(1.5) .for(:amount)
      expect(subject).to_not allow_value(-1)  .for(:amount)
      expect(subject).to_not allow_value(-1.5).for(:amount)
    end
  end
end
