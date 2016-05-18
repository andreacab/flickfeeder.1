class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper

  def create
    super
  end

  def new
    super
  end

  def edit
    puts '*********** FUCK *********** IN registration edit'
    super
  end
end
