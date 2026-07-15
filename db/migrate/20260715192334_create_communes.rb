class CreateCommunes < ActiveRecord::Migration[8.1]
  def change
    create_table :communes do |t|
      t.string :name
      t.string :postal_code

      t.timestamps
    end
  end
end
