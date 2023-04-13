require "httparty" 
require "nokogiri"
require "open-uri"
require "parallel"

# defining a class to store the scraped data
class OtomotoProduct
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

class Scraper
	def initialize(url)
		response = HTTParty.get( url, { 
			headers: { 
				"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
			}, 
		})
		# parsing the HTML document returned by the server 
		@document = Nokogiri::HTML(response.body)
	end
end

class OtomotoScraper < Scraper
	def scrapeProducts() 
		html_products = @document.css("article.eayvfn60")
		@otomoto_products = []
		html_products.each do |html_product| 			
			# storing the scraped data in a OtomotoProduct object 
			otomoto_product = scrapeProduct(html_product) 
			# adding the OtomotoProduct to the list of scraped objects 
			@otomoto_products.push(otomoto_product) 
		end
	end
	def scrapeProduct(product)
		url = product.css("div")[0].css("h2").css("a").first.attribute("href").value 
		obraz = product.css("div").css("img").first.attribute("src").value
		obraz = obraz.sub(";","%3B")
		nazwa = product.css("h2").css("a").first.text
		cena = product.css("div").css("div").css("span.eayvfn611").first.text
		tabela = scrapeTabela(product)
		OtomotoProduct.new(url, obraz, nazwa, cena, tabela)
	end
	def scrapeTabela(product)
		tabela = product.css("li.ooa-1k7nwcr.e19ivbs0")
		i = 0
		if !tabela[i].text.chr.match(/[0-9]/) then
			i += 1
		end
		rok = tabela[i].text
		i += 1
		if !tabela[i].text.include?("km") then
			przebieg = ""
		else
			przebieg = tabela[i].text
			i += 1
		end
		if !tabela[i].text.include?("cm3") then
			pojemnosc = ""
		else
			pojemnosc = tabela[i].text
			i += 1
		end
		if tabela[i].text.chr.match(/[0-9]/) then
			rodzaj = ""
		else
			rodzaj = tabela[i].text
			i += 1
		end
		tabela = "#{rok};#{przebieg};#{pojemnosc};#{rodzaj}"
		tabela
	end
	def exportToCSV()
		csv_headers = ["url", "obraz", "nazwa", "cena", "rok", "przebieg", "pojemnosc", "rodzaj"] 
		CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv| 
			@otomoto_products.each do |otomoto_product| 
				csv << otomoto_product.to_s.split(";")
			end 
		end
	end
	def scrapeProductsToCSV()
		scrapeProducts()
		exportToCSV()
	end
end

scrp = OtomotoScraper.new("https://www.otomoto.pl/osobowe")
scrp.scrapeProductsToCSV()
