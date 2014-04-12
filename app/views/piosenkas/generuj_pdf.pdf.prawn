pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"

@spis.each do |id, piosenka|
	piosenki = [[]]
	tytul = pdf.make_cell(:content => "#{piosenka[:tytul]}", :colspan => 3, :align => :center, :size => 25 )
	akordy = pdf.make_cell(:content => "#{piosenka[:akordy]}")
	if piosenka[:obrazki_akordow] != '' && piosenka[:obrazki_akordow].any?
		obrazki = [[]]
		piosenka[:obrazki_akordow].each do |nazwa,obrazek|
			sciezka = "#{Rails.root.join('app', 'assets', 'images', obrazek)}"
			komorkaNazwa = pdf.make_cell(:content => "#{nazwa}", :valign => :center)
			obrazki += [[komorkaNazwa, {:image => sciezka}]]
		end
	else
		obrazki = ""
	end
	pierwsza_strona_tekst = piosenka[:tekst][0].join("\n")
	pierwsza_strona = pdf.make_cell(:content => "#{pierwsza_strona_tekst}")
	piosenki += [[tytul], [pierwsza_strona, akordy, obrazki]]
	piosenka[:tekst].shift
	if piosenka[:tekst].any? 
		piosenka[:tekst].each do |fragment|
			strona_tekst = fragment.join("\n")
			strona = pdf.make_cell(:content => "#{strona_tekst}", :colspan => 3)
			piosenki += [[strona]]
		end
	end
	pdf.table(piosenki, :column_widths => {0 => 310}, :cell_style => {:border_width => 0})
	if !piosenka[:ostatnia]
		pdf.start_new_page
	end
end

number_pages "<page>", { :start_count_at => 0, :page_filter => :all, :at => [bounds.right - 550, 0], :align => :center, :size => 14 }