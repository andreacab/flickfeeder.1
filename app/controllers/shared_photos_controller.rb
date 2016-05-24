class SharedPhotosController < ApplicationController
  # before_filter :check_token, only: [:editor, :show]

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

    token = Token.where(token: params[:token]).first
    @shared_photos = Media.where(token_id: token.id)
  end

  def show
    token = Token.where(token: params[:token]).first
    @shared_photos = Media.where(token_id: token.id)
  end

  private

    def check_token
      if !Token.where(token: params[:token]).any?
        # binding.pry
        redirect_to controller: 'shared_photos', action: 'client_access', failed: 'true'
      end
    end

end
