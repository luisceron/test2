require 'rails_helper'

RSpec.describe TotalizerTransactionsService, type: :service do
  let!(:user) {create(:user)}
  
  let!(:transaction1)  {create(:transaction, user: user, transaction_type: :out, amount:    5.50)}
  let!(:transaction2)  {create(:transaction, user: user, transaction_type: :out, amount:   15.40)}
  let!(:transaction3)  {create(:transaction, user: user, transaction_type: :in,  amount: 1000.00)}
  let!(:transaction4)  {create(:transaction, user: user, transaction_type: :out, amount:  500.00)}
  let!(:transaction5)  {create(:transaction, user: user, transaction_type: :in,  amount:  205.50)}
  let!(:transaction6)  {create(:transaction, user: user, transaction_type: :in,  amount:  100.00)}
  let!(:transaction7)  {create(:transaction, user: user, transaction_type: :out, amount:    0.40)}
  let!(:transaction8)  {create(:transaction, user: user, transaction_type: :out, amount:  150.80)}
  let!(:transaction9)  {create(:transaction, user: user, transaction_type: :out, amount:   25.50)}
  let!(:transaction10) {create(:transaction, user: user, transaction_type: :out, amount:   65.99)}
    
  let!(:totalizer_transactions_service) {TotalizerTransactionsService.new(user.transactions)}

  context "totalizing transactions" do
    it "must return the correct assignment" do
      expect(user.transactions.count).to eq(10)
      expect(totalizer_transactions_service.transactions.count).to     eq(user.transactions.count)
      expect(user.transactions.scope_in.count).to eq(3)
      expect(totalizer_transactions_service.transactions_in.count).to  eq(user.transactions.scope_in.count)
      expect(user.transactions.scope_out.count).to eq(7)
      expect(totalizer_transactions_service.transactions_out.count).to eq(user.transactions.scope_out.count)
    end

    it "must totalize IN transactions" do
      expect(totalizer_transactions_service.totalize_transactions_in).to eq(1305.50)
    end

    it "must totalize OUT transactions" do
      expect(totalizer_transactions_service.totalize_transactions_out).to eq(763.59)
    end

    it "must return transactions total" do
      expect(totalizer_transactions_service.calculate_total).to eq(541.91)
    end
  end
end
