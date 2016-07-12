class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  attr_accessor :advanced_search

  def index
    @transactions = index_object @user.transactions, params
    check_advanced_search
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
    save_object @transaction, {fem: true}
  end

  def update
    @transaction.assign_attributes(transaction_params)
    save_object @transaction, {fem: true}
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

    def check_advanced_search
      if params[:q]
        params[:q].each do |key, value|
          if key.to_sym != :description_cont
            return self.advanced_search = true if value != ""
          end
        end
        self.advanced_search = false
      end
    end
end
