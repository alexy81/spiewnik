class PiosenkiAkordy < ActiveRecord::Migration
  def self.up
    Piosenka.find(:all).each do |piosenka|
      akordy = piosenka.akordy.squish.gsub(/[()]/i,'')
      akordyTab = akordy.split(' ')
      akordyTmp = Array.new
      akordyTab.each do |nazwa|
        unless akordyTmp.include?(nazwa)
          akordyTmp << nazwa
          if Akord.exists?(:nazwa => nazwa)
            akord = Akord.find(:first, :conditions => { :nazwa => nazwa })
            if !PiosenkaAkord.exists?(:piosenka_id=>piosenka.id, :akord_id=>akord.id) 
              piosenka.piosenka_akords.create(:piosenka_id=>piosenka.id, :akord_id=>akord.id)
            end
          end
        end
      end
    end
  end
end
