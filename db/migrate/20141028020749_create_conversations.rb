class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
