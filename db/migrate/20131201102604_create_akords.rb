class CreateAkords < ActiveRecord::Migration
  def change
    create_table :akords do |t|
      t.string :nazwa
      t.string :obrazek

      t.timestamps
    end
  end
end
