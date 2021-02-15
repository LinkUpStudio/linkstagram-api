class AccountController < ApplicationController
  before_action :authenticate

  def show
    render json: AccountBlueprint.render(current_user, view: :private), status: 200
  end

  def update
    if current_user.update(account_params)
      return render json: AccountBlueprint.render(current_user, view: :private), status: 200
    end

    render json: { errors: current_user.errors }, status: 422
  end

  private

  def account_params
    params.require(:account).permit(:description, :username, :profile_photo)
  end
end
