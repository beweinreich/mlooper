class ChangeDirectionToStringInEmails < ActiveRecord::Migration
  def change
    change_column :emails, :direction, :string
  end
end
