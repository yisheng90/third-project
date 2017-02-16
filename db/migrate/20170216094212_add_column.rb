class AddColumn < ActiveRecord::Migration[5.0]
  def change
    add_reference :freelancers, :profession_id, references: :professions, index: true
  end
end
