class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.boolean :read, default: false
      t.references :enquiry, foreign_key: true
      t.references :sender, foreign_key: true

      t.timestamps
    end
  end
end
