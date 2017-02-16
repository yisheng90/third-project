class RemoveColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :professions, :freelancer_id, :references
  end
end
