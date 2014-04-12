class PiosenkaAkord < ActiveRecord::Base
  belongs_to :piosenka
  belongs_to :akord
end
