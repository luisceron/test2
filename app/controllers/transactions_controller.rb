class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  def index
    @transactions = index_object @user.transactions, params
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
    save_object @transaction
  end

  def update
    @transaction.assign_attributes(transaction_params)
    save_object @transaction
  end

  def destroy
    destroy_object @transaction, user_transactions_url(@user)
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
