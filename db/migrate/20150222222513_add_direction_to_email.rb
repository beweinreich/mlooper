class AddDirectionToEmail < ActiveRecord::Migration
  def change
    add_column :emails, :direction, :integer
  end
end
