class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.bigint :user_id
      t.bigint :home_id
      # t.references :home, foreign_key: true
      t.text :identifier
      t.text :device_name

      t.timestamps
    end
  end
end
