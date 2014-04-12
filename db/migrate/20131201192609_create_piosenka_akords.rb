class CreatePiosenkaAkords < ActiveRecord::Migration
  def change
    create_table :piosenka_akords , :id => false do |t|
      t.references :piosenka, :akord
    end
  end
end
