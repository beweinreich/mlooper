class AddLooperTitleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :looper_title, :string
  end
end
