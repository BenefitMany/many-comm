class InitialSchema < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.boolean :admin, default: false, null: false
      t.string :identifier, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :new_email
      t.string :password_digest, null: false
      t.string :password_change, null: false, default: false
      t.string :perishable_token
      t.string :time_zone
      t.string :user_status
      t.datetime :activated_at
      t.datetime :created_at
    end
    add_index :users, :email
    add_index :users, :user_status
    add_index :users, :identifier, unique: true

    create_table :user_login_entries do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.datetime :created_at
    end

    create_table :sessions do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.string :access_token, null: false
      t.boolean :change_password
      t.jsonb :cached_user
      t.datetime :created_at
    end
    add_index :sessions, :access_token

    create_table :visitors do |t|
      t.string :identifier, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.string :fake_name, null: false
      t.string :to_number
      t.string :from_number
      t.string :chat_window_status
      t.json :properties, default: {}
      t.datetime :created_at
    end
    add_index :visitors, :identifier, unique: true

    create_table :conversations do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :visitor, index: true, foreign_key: true, null: false
      t.string :identifier, null: false
      t.datetime :created_at
      t.datetime :closed_at
    end
    add_index :conversations, :identifier, unique: true
    add_index :conversations, :created_at
    add_index :conversations, :closed_at

    create_table :messages do |t|
      t.references :conversation, index: true, foreign_key: true, null: false
      t.references :messageable, polymorphic: true, index: true, null: false
      t.text :message, null: false
      t.datetime :created_at
    end

    create_table :webhook_entries do |t|
      t.text :data
      t.datetime :created_at
    end

    create_table :chat_access_keys do |t|
      t.string :access_key, null: false
      t.string :access_key_salt, null: false
      t.integer :accessed, default: 0, null: false
      t.datetime :created_at
      t.datetime :deleted_at
    end

    create_table :phone_numbers do |t|
      t.string :twilio_sid
      t.string :name, null: false
      t.string :number, null: false
      t.jsonb :details, null: false, default: {}
      t.datetime :created_at
      t.datetime :deleted_at
    end

    create_table :autoresponders do |t|
      t.string :response_type, null: false
      t.boolean :active, null: false, default: false
      t.datetime :status_changed_at
      t.text :message, null: false
      t.datetime :created_at
    end
    add_index :autoresponders, :response_type

    create_table :autoresponder_logs do |t|
      t.references :autoresponder, index: true, foreign_key: true, null: false
      t.text :message
      t.string :checksum
      t.datetime :created_at
    end
    add_index :autoresponder_logs, :checksum
  end
end
