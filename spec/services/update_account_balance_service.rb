require 'rails_helper'

RSpec.describe UpdateAccountBalanceService, type: :service do
  let!(:user) {create(:user)}
  let!(:account) {create(:account, user: user, balance: 100.00)}

  context "adding to the account balance" do
    it "with a new IN Transaction" do
      create(:transaction, user: user, account: account, transaction_type: :in, amount: 100.50)
      expect(account.balance).to eq(200.50)
    end

    it "with a new OUT Transaction" do
      create(:transaction, user: user, account: account, transaction_type: :out, amount: 50.50)
      expect(account.balance).to eq(49.50)
    end
  end

  context "updating to the account balance" do
    it "with a new IN Transaction for an IN Transaction" do
      transaction = create(:transaction, user: user, account: account, transaction_type: :in, amount: 100.00)
      transaction.amount = 150.00
      transaction.save
      expect(account.balance).to eq(250.00)
    end

    it "with a new OUT Transaction for an OUT Transaction" do
      transaction = create(:transaction, user: user, account: account, transaction_type: :out, amount: 50.00)
      transaction.amount = 80.00
      transaction.save
      expect(account.balance).to eq(20.00)
    end

    it "with a new IN Transaction for an OUT Transaction" do
      transaction = create(:transaction, user: user, account: account, transaction_type: :in, amount: 100.00)
      transaction.transaction_type = :out
      transaction.amount = 40.00
      transaction.save
      expect(account.balance).to eq(60.00)
    end

    it "with a new OUT Transaction for an IN Transaction" do
      transaction = create(:transaction, user: user, account: account, transaction_type: :out, amount: 50.00)
      transaction.transaction_type = :in
      transaction.amount = 70.00
      transaction.save
      expect(account.balance).to eq(170.00)
    end
  end

  context "subtracting to the account balance" do
    it "for an IN Transaction" do
      transaction = create(:transaction, user: user, account: account, transaction_type: :in, amount: 300.00)
      transaction.destroy
      expect(account.balance).to eq(100.00)
    end

    it "for an OUT Transaction" do
      transaction = create(:transaction, user: user, account: account, transaction_type: :out, amount: 75.00)
      transaction.destroy
      expect(account.balance).to eq(100.00)
    end
  end
  
end
