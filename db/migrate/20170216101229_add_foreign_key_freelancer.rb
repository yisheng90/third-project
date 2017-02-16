class AddForeignKeyFreelancer < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :freelancers, :professions
  end
end
