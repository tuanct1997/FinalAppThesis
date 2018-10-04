class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      
      t.text :email
      t.text :password
      t.text :username
      t.text :phone_number
      t.text :password_digest

      t.timestamps
    end
  end
end
