# Database Design Excersize

## Assignment
Database and model design with queries
We want to model providers (e.g. dietitians), their clients, and journal entries.
* Both providers and clients have a name and an email address.
* Providers have many clients
* Clients usually have one Provider but can have more than one.
* Clients have a plan that they paid for, signified by the string "basic" or "premium".
For each provider that a client is signed up with, they have 1 plan.
* Clients post journal entries. These consist of freeform text.

## Migrations

4 Migrations are required for this project. Foreign keys and suggested indexes have been added.

```
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
```

```
class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
    add_index :clients, :email, unique: true
  end
end
```

```
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

```

```
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
```

## Schema
The resulting schema from the migrations
```
ActiveRecord::Schema[7.1].define(version: 2024_08_14_160325) do
  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journal_entries", force: :cascade do |t|
    t.integer "provider_id"
    t.integer "client_id"
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id", "client_id", "created_at"], name: "idx_on_provider_id_client_id_created_at_25be84f163"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "provider_id"
    t.integer "client_id"
    t.string "plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id", "client_id"], name: "index_subscriptions_on_provider_id_and_client_id", unique: true
  end

  add_foreign_key "journal_entries", "clients"
  add_foreign_key "journal_entries", "providers"
  add_foreign_key "subscriptions", "clients"
  add_foreign_key "subscriptions", "providers"
end
```

## Models
Relationships are added to the models. Additional validation can be added down the line.
```
class Client < ApplicationRecord
  has_many :subscriptions
  has_many :providers, through: :subscriptions
  has_many :journal_entries
end
```

```
class Provider < ApplicationRecord
  has_many :subscriptions
  has_many :clients, through: :subscriptions
  has_many :journal_entries
end
```

```
class Subscription < ApplicationRecord
  belongs_to :client
  belongs_to :provider
end
```

```
class JournalEntry < ApplicationRecord
  belongs_to :provider
  belongs_to :client
end
```

## Queries

* Find all clients for a particular provider
```
Provider.find(id).clients
```
* Find all providers for a particular client
```
Client.find(id).providers
```
* Find all of a particular client's journal entries, sorted by date posted
```
Client.find(id).journal_entries.order(:created_at)
```
* Find all of the journal entries of all of the clients of a particular provider, sorted by
date posted
```
Provider.find(id).journal_entries.order(:created_at)
```


