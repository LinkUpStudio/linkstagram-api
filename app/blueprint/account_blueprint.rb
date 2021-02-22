# frozen_string_literal: true

class AccountBlueprint < Blueprinter::Base
  identifier :username

  fields :description, :profile_photo_url, :followers,
         :following, :first_name, :last_name, :job_title

  view :private do
    field :email
  end
end
