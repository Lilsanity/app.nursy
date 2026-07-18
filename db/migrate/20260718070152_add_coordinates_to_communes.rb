class AddCoordinatesToCommunes < ActiveRecord::Migration[8.1]
  def change
    add_column :communes, :latitude, :float
    add_column :communes, :longitude, :float
  end
end
