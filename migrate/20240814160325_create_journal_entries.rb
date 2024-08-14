class CreateJournalEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :journal_entries do |t|
      t.integer :provider_id
      t.integer :client_id
      t.string :title
      t.text :content
      t.timestamps
    end
    add_foreign_key :journal_entries, :providers, column: :provider_id
    add_foreign_key :journal_entries, :clients, column: :client_id
    add_index :journal_entries, [:provider_id, :client_id, :created_at]
  end
end
