class CheckPeriodsService

  def self.check(current_user)
    current_user.accounts.each do |account|
      last_period = account.periods.last
      
      last_year     = last_period.year
      last_month    = last_period.month
      current_year  = Date.today.year
      current_month = Date.today.month


      if (last_year >= current_year) &&  (last_year > current_year || last_month > current_month)
        return nil
      end

      save_last_period(last_year, last_month, current_year, current_month, last_period, account)

      if last_year < current_year
        until last_year == current_year+1  do
          if last_year == current_year
            until last_month == current_month
              last_month +=1
              if last_month == current_month
                create_period(account, last_year, last_month, account.balance, nil)
              else
                create_period(account, last_year, last_month, account.balance, account.balance)
              end
            end
          else
            until last_month >= 12
              last_month +=1
              create_period(account, last_year, last_month, account.balance, account.balance)
            end
            last_month = 0
          end
          last_year +=1
        end
      else
        until last_month == current_month do
          last_month +=1
          if last_month == current_month
            create_period(account, last_year, last_month, account.balance, nil)
          else
            create_period(account, last_year, last_month, account.balance, account.balance)
          end
        end
      end

    end
  end

  private
    def self.save_last_period(last_year, last_month, current_year, current_month, last_period, account)
      if (last_year == current_year && last_month < current_month) || (last_year < current_year)
        last_period.end_balance = account.balance
        last_period.save!
      end
    end

    def self.create_period(account, last_year, last_month, start_balance, end_balance)
      Period.create!(account: account, year: last_year, month: last_month, start_balance: start_balance, end_balance: end_balance)
    end

end
