class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.integer :provider_id
      t.integer :client_id
      t.string :plan
      t.timestamps
    end
    add_foreign_key :subscriptions, :providers, column: :provider_id
    add_foreign_key :subscriptions, :clients, column: :client_id
    add_index :subscriptions, [:provider_id, :client_id], unique: true

  end
end
