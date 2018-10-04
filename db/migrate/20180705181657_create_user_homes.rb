class CreateUserHomes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_homes do |t|
      t.bigint :role, :default => 1
      t.references :user, foreign_key: true
      t.references :home, foreign_key: true

      t.timestamps
    end
  end
end
