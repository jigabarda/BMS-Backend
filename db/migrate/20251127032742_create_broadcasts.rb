class CreateBroadcasts < ActiveRecord::Migration[7.1]
  def change
    create_table :broadcasts do |t|
      t.string :title
      t.text :message
      t.string :status
      t.datetime :sent_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
