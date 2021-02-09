# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def authenticate
    rodauth.require_authentication
  end

  def current_account
    @current_account ||= Account.find(rodauth.session_value)
  rescue ActiveRecord::RecordNotFound
    rodauth.logout
    rodauth.login_required
  end
end
