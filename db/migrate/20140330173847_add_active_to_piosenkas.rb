class AddActiveToPiosenkas < ActiveRecord::Migration
  def change
    add_column :piosenkas, :active, :boolean, :null=>false, :default=>0
  end
end
