class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  def index
    @accounts = index_object @user.accounts, params
  end

  def show
  end

  def new
    @account = @user.accounts.new
  end

  def edit
  end

  def create
    @account = @user.accounts.new(account_params)
    save_object @account
  end

  def update
    @account.assign_attributes(account_params)
    save_object @account
  end

  def destroy
    destroy_object @account, user_accounts_url(@user)
  end

  private
    def set_account
      @account = Account.find(params[:id])
      @user = @account.user
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def account_params
      params.require(:account).permit(:user_id, :type, :name, :balance, :description)
    end
end
