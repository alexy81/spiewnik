json.array!(@piosenkas) do |piosenka|
  json.extract! piosenka, :tytul, :tekst, :akordy, :wykonawca, :obrazek
  json.url piosenka_url(piosenka, format: :json)
end
