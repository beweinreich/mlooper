class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :to
      t.string :from
      t.string :subject
      t.text :body
      t.text :raw_text
      t.text :raw_body
      t.text :headers
      t.text :raw_headers

      t.timestamps null: false
    end
  end
end
