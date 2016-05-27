class SharedPhotosController < ApplicationController
  before_filter :check_token, only: [:editor, :show]

  def access

  end

  def client_access
    if params[:failed] == 'true'
      @notice = "Invalid Token"
    else
      @notice = ''
    end
  end

  def editor
    @shared_photos = Media.where(token: params[:token])
  end

  def show
    @shared_photos = Media.where(token: params[:token], show_clients: true)
  end

  private

    def check_token
      if !Token.where(token: params[:token]).any?
        redirect_to controller: 'shared_photos', action: 'client_access', failed: 'true'
      end
    end

end
