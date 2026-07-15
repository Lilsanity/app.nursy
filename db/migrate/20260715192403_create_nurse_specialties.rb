class CreateNurseSpecialties < ActiveRecord::Migration[8.1]
  def change
    create_table :nurse_specialties do |t|
      t.references :nurse, null: false, foreign_key: true
      t.references :specialty, null: false, foreign_key: true

      t.timestamps
    end
  end
end
