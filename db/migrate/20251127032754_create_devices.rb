class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token       # renamed from push_token → token
      t.string :platform

      t.timestamps
    end

    add_index :devices, :token, unique: true
  end
end
