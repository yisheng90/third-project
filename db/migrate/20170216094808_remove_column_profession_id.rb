class RemoveColumnProfessionId < ActiveRecord::Migration[5.0]
  def change
    remove_column :freelancers, :profession_id_id, :references
  end
end
