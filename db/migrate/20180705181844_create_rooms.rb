class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.text :room_name
      t.references :home, foreign_key: true

      t.timestamps
    end
  end
end
