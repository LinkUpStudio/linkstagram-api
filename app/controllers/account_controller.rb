class AccountController < ApplicationController
  def update
    authenticate
    render :json, status: 200 if current_user.update(account_params)
  end

  private

  def account_params
    params.require(:account).permit(:description, :username, :profile_photo)
  end
end
