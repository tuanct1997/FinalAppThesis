class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.references :device, foreign_key: true
      t.text :temperature
      t.text :acceleration
      t.text :location
      t.text :motion

      t.timestamps
    end
  end
end
