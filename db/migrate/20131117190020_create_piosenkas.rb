class CreatePiosenkas < ActiveRecord::Migration
  def change
    create_table :piosenkas do |t|
      t.string :tytul
      t.text :tekst
      t.text :akordy
      t.string :wykonawca
      t.string :obrazek

      t.timestamps
    end
  end
end
