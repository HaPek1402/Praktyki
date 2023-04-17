class OtomotoProduct
    attr_reader :url, :obraz, :nazwa, :cena, :tabela
	def initialize(url, obraz, nazwa, cena, tabela)
		@url = url
		@obraz = obraz
		@nazwa = nazwa
		@cena = cena
		@tabela = tabela
	end
	def to_s
		"#{@url};#{@obraz};#{@nazwa};#{@cena};#{@tabela}"
	end
end
