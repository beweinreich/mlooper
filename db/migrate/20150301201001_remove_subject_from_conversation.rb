class RemoveSubjectFromConversation < ActiveRecord::Migration
  def change
    remove_column :conversations, :subject, :string
  end
end
