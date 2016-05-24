class Users::RegistrationsController < Devise::RegistrationsController

  include ApplicationHelper
  before_filter :configure_permitted_parameters

  def create
    super

    first_name = params[:user]["first_name"] = params[:user]["first_name"].capitalize
    last_name = params[:user]["last_name"] = params[:user]["last_name"].capitalize
    current_user.update_attributes(first_name: first_name, last_name: last_name)
    if current_user.email.include?('@flickfeeder.com')
      current_user.update_attributes(user_type: "admin")
    end
  end

  def new
    @organizations = Organization.all
    super
  end

  def edit
    super
  end



  protected
   ## Strong Parameters
   def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up , keys: [:first_name, :last_name ,
        :email, :password, :password_confirmation, :avatar])

    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name ,
        :email, :password, :password_confirmation, :avatar,:current_password])

  end
end
