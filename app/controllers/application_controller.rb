# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: 'User is not allowed to perform this action' }, status: 401
  end

  def to_int(str)
    Integer(str || '')
  rescue ArgumentError, TypeError
    0
  end

  def authenticate
    rodauth.require_authentication
  end

  def current_user
    @current_account ||= Account.find(rodauth.session_value)
  rescue ActiveRecord::RecordNotFound
    rodauth.login_required
  end
end
