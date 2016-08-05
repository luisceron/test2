class CheckPeriodsService

  def self.check(current_user)
    current_user.accounts.each do |account|
      last_period = account.periods.last
      
      last_year     = last_period.year
      last_month    = last_periord.month
      current_year  = Date.today.year
      current_month = Date.today.month

      if last_year != current_year && last_month != current_month

        # If month changes, calculate last_balance and save!
        last_balance = TotalizerTransactionsService.new(account.transactions).calculate_total
        last_period.end_balance = last_balance
        last_period.save

        if last_year < current_year

          
          # CONTINUE HERE
          until last_year == current_year do
            until last_month == current_month do
              last_month +=1
              Period.create(account: account, year: last_year, month: last_month, start_balance: last_period.end_balance)
            end
            last_year +=1
          end


        else
          until last_month == current_month do
            last_month +=1
            if last_month == current_month
              Period.create(account: account, year: last_year, month: last_month, start_balance: last_period.end_balance)
            else
              Period.create(account: account, year: last_year, month: last_month, start_balance: last_period.end_balance, end_balance: last_period.end_balance)
            end
          end
        end
      end

    end
  end

end


# Simple Test (Include only one single month)
# last_year = 2016 / last_month =  7 / current_year = 2016 / current_month = 8


# Tests
# last_year = 2016 / last_month =  4 / current_year = 2016 / current_month = 7
# 
# last_year = 2016 / last_month =  7 / current_year = 2016 / current_month = 7
# 
# last_year = 2016 / last_month = 10 / current_year = 2016 / current_month = 7
# 
# 
# 
# last_year = 2015 / last_month =  4 / current_year = 2016 / current_month = 7
# 
# last_year = 2015 / last_month =  7 / current_year = 2016 / current_month = 7
# 
# last_year = 2015 / last_month = 10 / current_year = 2016 / current_month = 7
# 
