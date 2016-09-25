class CreateReplacements < ActiveRecord::Migration
  def change
    create_table :replacements do |t|
      t.string :word
      t.string :replacement_word
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
