class UsersController < ApplicationController
  skip_before_action :check_if_user_is_owner
  before_action :only_admin, only: [:index, :new, :create, :destroy]
  before_action :only_current_user, only: [:show, :edit, :update, :edit_password, :update_password, :remove_account]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user_id, only: [:edit_password, :update_password, :remove_account]

  def index
    @users = index_object User, params
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    save_object @user
  end

  def update
    @user.assign_attributes(user_params)
    save_object @user
  end

  def destroy
    destroy_object @user, users_url
  end

  def edit_password
  end

  def update_password
    update_user_password
  end

  def remove_account
    remove_user_account
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_user_id
      @user = User.find(params[:user_id])
    end

    def user_params
      params.require(:user).permit(:email, :name, :admin, :current_password, :password, :password_confirmation)
    end

    def user_params_destroy
      params.require(:user).permit(:typed_email)
    end

    def update_user_password
      if current_user.admin
        if user_params[:password] == user_params[:password_confirmation]
          if @user.update(user_params)
            if @user == current_user
              sign_in @user, bypass: true
            else
              sign_in current_user, bypass: true
            end
            redirect_to @user, notice: t('controller.password_changed')
          end
        else
          @user.errors.add(:password_confirmation, User.human_attribute_name(:admin_update_password_error))
          render :edit_password
        end
      else
        if @user.update_with_password(user_params)
          sign_in @user, bypass: true
          redirect_to @user, notice: t('controller.password_changed')
        else
          render :edit_password
        end
      end
    end

    def remove_user_account
      @user.assign_attributes(user_params_destroy)

      if @user.email == @user.typed_email
        @user.destroy
        if current_user.admin && current_user != @user
          redirect_to users_path, notice: User.human_attribute_name(:destroyed_successfully)
        else
          redirect_to new_user_session_path, notice: User.human_attribute_name(:destroyed_successfully)
        end
      else
        redirect_to @user, alert: User.human_attribute_name(:invalid_email)
      end
    end
end
