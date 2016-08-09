require 'rails_helper'

RSpec.describe CheckPeriodsService, type: :service do
  let!(:user) {create(:user)}

  let!(:account1) {create(:account, user: user)}
  let!(:account2) {create(:account, user: user)}
  
  def create_transactions(times, current_user, account_user, date, type, amount)
    for i in 1..times
      create(:transaction, user: current_user, account: account_user, date: date, transaction_type: type, amount: amount)
    end
  end
  
  describe "creating periods" do
    context "when creating an account" do 
      it "must create a period" do
        expect(account1.periods.count).to eq(1)
        account_period1 = account1.periods.first
        expect(account_period1.year).to eq(account1.created_at.year)
        expect(account_period1.month).to eq(account1.created_at.month)
        expect(account_period1.start_balance).to eq(100.00)
        expect(account_period1.end_balance).to be_nil

        expect(account2.periods.count).to eq(1)
        account_period2 = account2.periods.first
        expect(account_period2.year).to eq(account2.created_at.year)
        expect(account_period2.month).to eq(account2.created_at.month)
        expect(account_period2.start_balance).to eq(100.00)
        expect(account_period2.end_balance).to be_nil
      end
    end

    context "when checking periods with valid date" do 
      it "with same year and same month mustn't create period (Example: l_month=02/l_year=2016 and c_month=02/c_year=2016)" do
        current_year  = Date.today.year
        current_month = Date.today.month

        create_transactions(2, user, account1, "01/"+current_month.to_s+"/"+current_year.to_s, :in, 450.00)
        create_transactions(5, user, account1, "01/"+current_month.to_s+"/"+current_year.to_s, :out, 100.00)

        CheckPeriodsService.check(user)

        expect(account1.periods.count).to eq(1)
        expect(account1.balance).to eq(500.00)
        expect(account1.periods.first.end_balance).to be_nil
      end

      it "with same year and previous month must create new period (Example: l_month=02/l_year=2016 and c_month=03/c_year=2016)" do
        current_year  = Date.today.year
        current_month = Date.today.month

        first_period = account1.periods.first
        if first_period.month == 1
          first_period.year = current_year - 1
          first_period.month = 12
        else
          first_period.month = current_month - 1
        end
        first_period.save

        create_transactions(2, user, account1, "01/"+(current_month - 1).to_s+"/"+current_year.to_s, :in, 200.00)
        create_transactions(5, user, account1, "01/"+(current_month - 1).to_s+"/"+current_year.to_s, :out, 50.00)

        CheckPeriodsService.check(user)

        expect(account1.periods.count).to eq(2)
        expect(account1.balance).to eq(250.00)
        expect(account1.periods.first.end_balance).to eq(250.00)
        expect(account1.periods.second.start_balance).to eq(250.00)
        expect(account1.periods.second.end_balance).to be_nil
      end

      it "with same year and 3 previous months must create 3 new periods (Example: l_month=01/l_year=2016 and c_month=04/c_year=2016)" do
        current_year  = Date.today.year
        current_month = Date.today.month

        first_period = account1.periods.first
        if first_period.month == 1
          first_period.year = current_year - 1
          first_period.month = 10
        else
          first_period.month = current_month - 3
        end
        first_period.save

        create_transactions(2, user, account1, "01/"+(current_month - 3).to_s+"/"+current_year.to_s, :in, 700.00)
        create_transactions(5, user, account1, "01/"+(current_month - 3).to_s+"/"+current_year.to_s, :out, 100.00)

        CheckPeriodsService.check(user)

        expect(account1.periods.count).to eq(4)
        expect(account1.balance).to eq(1000.00)
        expect(account1.periods.first.end_balance).to eq(1000.00)
        expect(account1.periods.second.start_balance).to eq(1000.00)
        expect(account1.periods.third.start_balance).to eq(1000.00)
        expect(account1.periods.fourth.start_balance).to eq(1000.00)
        expect(account1.periods.fourth.end_balance).to be_nil
      end

      it "with different year and same month must create new periods (Example: l_month=01/l_year=2015 and c_month=01/c_year=2016)" do
        current_year  = Date.today.year
        current_month = Date.today.month

        first_period = account1.periods.first
        first_period.year = current_year - 1
        first_period.save

        create_transactions(2, user, account1, "01/"+current_month.to_s+"/"+(current_year - 1).to_s, :in, 2000.00)
        create_transactions(5, user, account1, "01/"+current_month.to_s+"/"+(current_year - 1).to_s, :out, 500.00)

        CheckPeriodsService.check(user)

        expect(account1.periods.count).to eq(13)
        expect(account1.balance).to eq(1600.00)
        expect(account1.periods.first.end_balance).to eq(1600.00)
        expect(account1.periods.second.start_balance).to eq(1600.00)
        expect(account1.periods.second.end_balance).to eq(1600.00)
        expect(account1.periods.third.start_balance).to eq(1600.00)
        expect(account1.periods.third.end_balance).to eq(1600.00)
        expect(account1.periods.fourth.start_balance).to eq(1600.00)
        expect(account1.periods.fourth.end_balance).to eq(1600.00)
        expect(account1.periods.last.start_balance).to eq(1600.00)
        expect(account1.periods.last.end_balance).to be_nil
      end
    end

    context "when checking periods with invalid date" do
      it "with greater year and same month must return nil (Example: l_month=01/l_year=2017 and c_month=01/c_year=2016)" do
        first_period = account1.periods.first
        first_period.year += 1
        first_period.save

        result = CheckPeriodsService.check(user)
        expect(account1.periods.count).to eq(1)
        expect(result).to be_nil
      end
    end
  end

end

  # let!(:t1)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t2)  {create(:transaction, user: user, account: account1, date: "01/02/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t3)  {create(:transaction, user: user, account: account1, date: "01/03/2015", transaction_type: :in,  amount: 1000.00)}
  # let!(:t4)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t5)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :in,  amount:  500.00)}
  # let!(:t6)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :in,  amount:  200.00)}
  # let!(:t7)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t8)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t9)  {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t10) {create(:transaction, user: user, account: account1, date: "01/01/2015", transaction_type: :out, amount:  100.00)}

  # let!(:t11) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:   50.00)}
  # let!(:t12) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:   50.00)}
  # let!(:t13) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :in,  amount:  500.00)}
  # let!(:t14) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:  100.00)}
  # let!(:t15) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :in,  amount:  200.00)}
  # let!(:t16) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :in,  amount:  200.00)}
  # let!(:t17) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:   50.00)}
  # let!(:t18) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:   50.00)}
  # let!(:t19) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:   50.00)}
  # let!(:t20) {create(:transaction, user: user, account: account2, date: "01/01/2015", transaction_type: :out, amount:   50.00)}
