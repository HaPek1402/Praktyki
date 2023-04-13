require "httparty" 
require "nokogiri"
require "open-uri"
require "parallel"

# defining a data structure to store the scraped data 
OtomotoProduct = Struct.new(:url, :obraz, :nazwa, :cena, :rok, :przebieg, :pojemnosc, :rodzaj) 
 
response = HTTParty.get("https://www.otomoto.pl/osobowe" , { 
	headers: { 
		"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
	}, 
})

# parsing the HTML document returned by the server 
document = Nokogiri::HTML(response.body)

# selecting all HTML product elements 
html_products = document.css("article.eayvfn60")

# initializing the list of objects 
# that will contain the scraped data 
otomoto_products = [] 
 
# iterating over the list of HTML products 
html_products.each do |html_product| 
	# extracting the data of interest 
	# from the current product HTML element 
	url = html_product.css("div")[0].css("h2").css("a").first.attribute("href").value 
	obraz = html_product.css("div").css("img").first.attribute("src").value
	obraz = obraz.sub(";","%3B")
	nazwa = html_product.css("h2").css("a").first.text
	cena = html_product.css("div").css("div").css("span.eayvfn611").first.text 
	tabela = html_product.css("li.ooa-1k7nwcr.e19ivbs0")
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
	#puts tabela.length()
	puts rok + "\t" + przebieg + "\t" + pojemnosc + "\t" + rodzaj
	# storing the scraped data in a OtomotoProduct object 
	otomoto_product = OtomotoProduct.new(url, obraz, nazwa, cena, rok, przebieg, pojemnosc, rodzaj) 
 
	# adding the OtomotoProduct to the list of scraped objects 
	otomoto_products.push(otomoto_product) 
end

# exporting to CSV...
# defining the header row of the CSV file 
csv_headers = ["url", "obraz", "nazwa", "cena", "rok", "przebieg", "pojemnosc", "rodzaj"] 
CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv| 
	# adding each otomoto_product as a new row 
	# to the output CSV file 
	otomoto_products.each do |otomoto_product| 
		csv << otomoto_product 
	end 
end
