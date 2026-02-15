class AddInviteTokenToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :invite_token, :string
    add_index :accounts, :invite_token, unique: true
  end
end
