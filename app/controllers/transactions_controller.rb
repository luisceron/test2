class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  def index
    if params[:q]
      @month = params[:q][:by_month]
      params[:q][:by_month] = Array(params[:q][:by_month].to_i).to_s
      @transactions = index_object_without_pagination @user.transactions, params
    else
      @month = Date.today.month
      params.merge!(q: {by_year: Date.today.year.to_s, by_month: Date.today.month.to_s })
      @transactions = index_object_without_pagination @user.transactions.current_month_scope, params
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
