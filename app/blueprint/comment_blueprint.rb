class CommentBlueprint < Blueprinter::Base
  identifier :id

  fields :message, :created_at
  association :commenter, blueprint: AccountBlueprint, view: :normal
end
