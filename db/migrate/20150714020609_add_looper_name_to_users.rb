class AddLooperNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :looper_name, :string
  end
end
