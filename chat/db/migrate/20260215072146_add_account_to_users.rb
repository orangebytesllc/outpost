class AddAccountToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :account, null: false, foreign_key: true
    add_column :users, :admin, :boolean, default: false, null: false
  end
end
