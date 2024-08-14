class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
    add_index :providers, :email, unique: true
  end
end
