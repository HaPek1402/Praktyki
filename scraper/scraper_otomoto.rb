require "httparty" 
require "nokogiri"
require "open-uri"
require "prawn"
require "yaml"

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

class Scraper
	def initialize(url)
		response = HTTParty.get( url, { 
			headers: { 
				"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
			}, 
		})
		@document = Nokogiri::HTML(response.body)
	end
end

class OtomotoScraper < Scraper
	def scrapeProducts
		html_products = @document.css("main").css("article")
		@otomoto_products = []
		html_products.each do |html_product| 			
			otomoto_product = scrapeProduct(html_product) 
			@otomoto_products.push(otomoto_product) 
		end
	end
	def scrapeProduct(product)
		url = product.css("div")[0].css("h2").css("a").first.attribute("href").value 
		obraz = product.css("div").css("img").first.attribute("src").value
		obraz = obraz.sub(";","%3B")
		nazwa = product.css("h2").css("a").first.text
		cena = product.css("div").css("div").css("span")
        cena = cena.find { |n| n.text.include?("PLN") }
        cena = cena.text
		tabela = scrapeTabela(product)
		OtomotoProduct.new(url, obraz, nazwa, cena, tabela)
	end
	def scrapeTabela(product)
		tabela = product.css("li")
		rok = ""
		przebieg = ""
		pojemnosc = ""
		rodzaj = ""

		tabela.each do |item|
			if !item.text.chr.match(/[0-9]/) and rok =="" then
			  next
			end
			if rok == ""
			  rok = item.text
			  next
			end
			if item.text.include?("km") and przebieg == ""
			  przebieg = item.text
			  next
			end
			if item.text.include?("cm3") and pojemnosc == ""
			  pojemnosc = item.text
			  next
			end
			if !item.text.include?(" ")
				rodzaj = item.text
			end
		end

		tabela = "#{rok};#{przebieg};#{pojemnosc};#{rodzaj}"
		tabela
	end
	def exportToCSV
		csv_headers = ["url", "obraz", "nazwa", "cena", "rok", "przebieg", "pojemnosc", "rodzaj"] 
		CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv| 
			@otomoto_products.each do |otomoto_product| 
				csv << otomoto_product.to_s.split(";")
			end 
		end
	end
	def scrapeProductsToCSV
		scrapeProducts
		exportToCSV
	end
end

class Configuration
	def initialize(configFile)
		@config = YAML.load_file(configFile)
	end
	def to_s
		"https://www.otomoto.pl/osobowe/#{@config['otomoto']['marka']}/od-#{@config['otomoto']['minrok']}?search%5Bfilter_float_year%3Ato%5D=#{@config['otomoto']['maxrok']}"
	end
end

conf = Configuration.new("config.yml")

scrp = OtomotoScraper.new(conf.to_s)
scrp.scrapeProductsToCSV
