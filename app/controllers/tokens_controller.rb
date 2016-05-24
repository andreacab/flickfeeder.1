class TokensController < ApplicationController
  def create
    # @token = Token.create(param)

    @token = Token.create(token: params["token"].upcase, user_id: current_user.id)
    redirect_to '/medias'
  end

  def new
    @token = Token.new()
  end
end
