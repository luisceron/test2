class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.integer :transaction_type
      t.datetime :date
      t.decimal :amount
      t.string :description

      t.timestamps null: false
    end
  end
end
