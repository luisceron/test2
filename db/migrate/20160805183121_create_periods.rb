class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :year
      t.integer :month
      t.decimal :start_balance
      t.decimal :end_balance
      t.references :account

      t.timestamps null: false
    end
  end
end
