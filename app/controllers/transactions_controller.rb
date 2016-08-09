class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  attr_accessor :period_for_current_date

  def index
    if params[:q]
      @month = params[:q][:by_month]
      params[:q][:by_month] = Array(params[:q][:by_month].to_i).to_s
      @transactions = index_object_without_pagination @user.transactions, params
      if params[:q][:account_id_eq]
        @periods = Period.where(year: params[:q][:by_year], month: params[:q][:by_year], account_id: params[:q][:account_id_eq])
      else
        @periods = Period.where(year: params[:q][:by_year], month: params[:q][:by_year])
      end
    else
      @month = Date.today.month
      params.merge!(q: {by_year: Date.today.year.to_s, by_month: Date.today.month.to_s })
      @transactions = index_object_without_pagination @user.transactions.current_month_scope, params
      @periods = Period.where(year: Date.today.year, month: Date.today.month)
      @period_for_current_date = true
    end
    @totalizer_transactions_service = TotalizerTransactionsService.new(@transactions)
  end

  def show
  end

  def new
    @transaction = @user.transactions.new
  end

  def edit
  end

  def create
    @transaction = @user.transactions.new(transaction_params)
    save_object @transaction, {path: user_transactions_url(@user), fem: true}
  end

  def update
    @transaction.assign_attributes(transaction_params)
    save_object @transaction, {path: user_transactions_url(@user), fem: true}
  end

  def destroy
    destroy_object @transaction, user_transactions_url(@user), {fem: true}
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
      @user = @transaction.user
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def transaction_params
      params.require(:transaction).permit(:account_id, :category_id, :transaction_type, :date, :amount, :description)
    end

end
