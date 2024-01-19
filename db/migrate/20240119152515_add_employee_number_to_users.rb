class AddEmployeeNumberToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :employee_number, :integer
  end
end
