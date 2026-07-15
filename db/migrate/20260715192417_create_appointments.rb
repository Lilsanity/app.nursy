class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :nurse, null: false, foreign_key: true
      t.references :availability, null: false, foreign_key: true
      t.string :care_type
      t.string :address
      t.string :status
      t.float :price

      t.timestamps
    end
  end
end
