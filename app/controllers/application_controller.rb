class ApplicationController < ActionController::Base

  def index
    @posts = Post.all
  end
end

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :basic_auth, if: :production?
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # ログインしていなければログインページに遷移
  def move_to_signin
    redirect_to new_user_session_path unless user_signed_in?
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, user_profile_attributes: [:first_name, :first_name_kana, :family_name, :family_name_kana, :birthday], delivery_addresses_attributes: [:first_name, :first_name_kana, :family_name, :family_name_kana, :postal_code, :prefecture_id, :city, :address, :building, :phone_number]] )
  end

  private
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:basic_auth][:user] &&
      password == Rails.application.credentials[:basic_auth][:pass]
    end
  end
  
  def production?
    Rails.env.production?
  end
end
