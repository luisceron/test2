class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :account_type
      t.string :name
      t.decimal :balance
      t.string :description

      t.timestamps null: false
    end
  end
end
