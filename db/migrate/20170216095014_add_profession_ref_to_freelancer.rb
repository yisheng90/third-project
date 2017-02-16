class AddProfessionRefToFreelancer < ActiveRecord::Migration[5.0]
  def change
    add_reference :freelancers, :profession, references: :professions, index: true
  end
end
