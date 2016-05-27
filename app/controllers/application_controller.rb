class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :features_on_hold, :current_design
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  def current_design
    image_design = ApplicationSettings.last.image_design
    image_design ? @current_design = "image-design" : @current_design = "blue-design"
  end

  def features_on_hold
    if ApplicationSettings.all == []
      ApplicationSettings.create
      Organization.create(name: "None")
    end
    @features_on_hold = ApplicationSettings.last.attributes.except("id").except("created_at").except("updated_at")
  end

  def required_user_to_have_organization
    if user_signed_in? && current_user.organization == nil
    end

  end
  #-> Prelang (user_login:devise)
  def require_user_signed_in
    unless user_signed_in?

      # If the user came from a page, we can send them back.  Otherwise, send
      # them to the root path.
      if request.env['HTTP_REFERER']
        fallback_redirect = :back
      elsif defined?(root_path)
        fallback_redirect = root_path
      else
        fallback_redirect = "/"
      end

      redirect_to fallback_redirect, flash: {error: "You must be signed in to view this page."}
    end
  end

end
