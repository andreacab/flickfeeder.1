class ApplicationSettingsController < ApplicationController

  def index
  end

  def update
    ApplicationSettings.last.update_attributes(application_settings_params)
    render nothing: true
  end

  private

  def application_settings_params
    params.permit(:devices_health, :dashboard, :photo_stream, :team, :events, :image_design)
  end

end
