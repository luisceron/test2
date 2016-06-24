class ApplicationController < ActionController::Base
  include BaseController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Authenticantion
  before_action :authenticate_user!
  before_action :check_if_user_is_owner

  before_action do
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private
    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
    end

    def only_admin
      unless current_user.admin?
        redirect_to root_path, alert: t('controller.access_denied')
      end
    end

    def only_current_user
      unless current_user.admin? || current_user.id == params[:id].to_i || current_user.id == params[:user_id].to_i
        redirect_to root_path, alert: t('controller.access_denied')
      end
    end

    def check_if_user_is_owner
      user = controller_name.classify.constantize.find(params[:id].to_i).try(:user) if !params[:user_id]
      unless current_user == user || current_user.id == params[:user_id].to_i
        redirect_to root_path, alert: t('controller.access_denied')
      end
    end
end
