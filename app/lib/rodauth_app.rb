# frozen_string_literal: true

class RodauthApp < Rodauth::Rails::App
  configure json: :only do
    # List of authentication features that are loaded.
    enable :create_account, :login, :logout, :jwt

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    login_column :username
    email_to do
      account[:email]
    end
    
    # ==> General
    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.

    # Specify the controller used for view rendering and CSRF verification.
    rails_controller { RodauthController }

    # Store account status in a text column.
    # account_status_column :status
    # account_unverified_status_value "unverified"
    # account_open_status_value "verified"
    # account_closed_status_value "closed"

    # Store password hash in a column instead of a separate table.
    # account_password_hash_column :password_digest

    # Set password when creating account instead of when verifying.
    # verify_account_set_password? false

    # Redirect back to originally requested location after authentication.
    # login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    # reset_password_autologin? true

    # Delete the account record when the user has closed their account.
    # delete_account_on_close? true

    # Redirect to the app from login and registration pages if already logged in.
    # already_logged_in { redirect login_redirect }

    # ==> JWT
    # Set JWT secret, which is used to cryptographically protect the token.
    jwt_secret Rails.application.credentials.jwt_secret

    # Don't require login confirmation param.
    require_login_confirmation? false

    # Don't require password confirmation param.
    require_password_confirmation? false

    # ==> Emails
    # Uncomment the lines below once you've imported mailer views.
    # create_reset_password_email do
    #   RodauthMailer.reset_password(email_to, reset_password_email_link)
    # end
    # create_verify_account_email do
    #   RodauthMailer.verify_account(email_to, verify_account_email_link)
    # end
    # create_verify_login_change_email do |login|
    #   RodauthMailer.verify_login_change(login, verify_login_change_old_login, verify_login_change_new_login, verify_login_change_email_link)
    # end
    # create_password_changed_email do
    #   RodauthMailer.password_changed(email_to)
    # end
    # # create_email_auth_email do
    # #   RodauthMailer.email_auth(email_to, email_auth_email_link)
    # # end
    # # create_unlock_account_email do
    # #   RodauthMailer.unlock_account(email_to, unlock_account_email_link)
    # # end
    # send_email do |email|
    #   # queue email delivery on the mailer after the transaction commits
    #   db.after_commit { email.deliver_later }
    # end

    # In the meantime you can tweak settings for emails created by Rodauth
    # email_subject_prefix "[MyApp] "
    # email_from "noreply@myapp.com"
    # send_email(&:deliver_later)
    # reset_password_email_body { "Click here to reset your password: #{reset_password_email_link}" }

    # ==> Flash
    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Change minimum number of password characters required when creating an account.
    password_minimum_length 6

    # ==> Hooks
    # Validate custom fields in the create account form.
    before_create_account do
      unless (username = param_or_nil("username"))
        throw_error_status(422, "username", "must be present")
      end
      account[:username] = username
      account[:profile_photo] = param("profile_photo")
      account[:followers] = rand(0..1000)
      account[:following] = rand(0..1000)
    end

    # Perform additional actions after the account is created.
    # after_create_account do
    # end

    # Do additional cleanup after the account is closed.
    # after_close_account do
    #   Profile.find_by!(account_id: account[:id]).destroy
    # end

    # ==> Redirects
    # Redirect to home page after logout.
    logout_redirect '/'

    # Redirect to wherever login redirects to after account verification.
    # verify_account_redirect { login_redirect }

    # Redirect to login page after password reset.
    # reset_password_redirect { login_path }

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]
  end

  # ==> Multiple configurations
  # configure(:admin) do
  #   enable :http_basic_auth
  #
  #   prefix "/admin"
  #   session_key :admin_id
  # end

  route(&:rodauth)
end
