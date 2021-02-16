class AccountBlueprint < Blueprinter::Base
  identifier :username

  fields :description, :profile_photo, :followers,
         :following

  view :private do
    field :email
  end
end

# gem bullet
# make profiles get one account with their posts
# in blueprint post + its author
