class AddBeneficiaryToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_column :appointments, :beneficiary_name, :string
    add_column :appointments, :beneficiary_phone, :string
  end
end
