class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :pass
      t.string :email
      t.boolean :active
      t.boolean :admin
      t.boolean :moderator

      t.timestamps
    end
  end
end
