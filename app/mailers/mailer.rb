class Mailer < ActionMailer::Base
  default from: "info@skpb.lublin.pl"
  
  def nowa_piosenka(user,tytul,id)
    @user = user
    @tytul = tytul
    @id = id
    @url = "https://spiewnik.nigdy.pl/edit/" + id.to_s
    @recipients = User.find(:all, :conditions => "(admin = 1) OR (moderator = 1)")
    if !@recipients.empty?
      @recipients.each do |recipient|
        mail(to: recipient.email, subject: 'Nowa piosenka w śpiewniku SKPB Lublin')
      end
    end
    
  end
  
  def nowy_uzytkownik(user)
    @user = user
    @recipients = User.find(:all, :conditions => "admin = 1")
    if !@recipients.empty?
      @recipients.each do |recipient|
        mail(to: recipient.email, subject: 'Nowy użytkownik w śpiewniku SKPB Lublin')
      end
    end
    
  end
  
end
