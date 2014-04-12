class PiosenkasAkords < ActiveRecord::Migration
  def self.up
    create_table 'piosenkas_akords', :id => false do |t|
      t.belongs_to :piosenka
      t.belongs_to :akord
    end
  end
end
