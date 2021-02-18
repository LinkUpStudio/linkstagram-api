# frozen_string_literal: true

class AccountBlueprint < Blueprinter::Base
  identifier :username

  fields :description, :profile_photo_url, :followers,
         :following

  view :private do
    field :email
  end
end
