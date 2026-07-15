class CreateNurses < ActiveRecord::Migration[8.1]
  def change
    create_table :nurses do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :rpps_number
      t.references :commune, null: false, foreign_key: true
      t.float :average_rating
      t.boolean :is_verified

      t.timestamps
    end
  end
end
