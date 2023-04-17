require "nokogiri"
require_relative 'scraper.rb'
require_relative 'otomoto_product.rb'

class OtomotoScraper
	include Scraper
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
