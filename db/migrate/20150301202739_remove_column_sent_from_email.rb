class RemoveColumnSentFromEmail < ActiveRecord::Migration
  def change
    remove_column :emails, :sent, :integer
  end
end
