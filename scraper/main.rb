require_relative 'pdfgenerator.rb'
require_relative 'configuration.rb'
require_relative 'otomoto_scraper.rb'

conf = Configuration.new("config.yml")

scrp = OtomotoScraper.new(conf.to_s)
scrp.scrapeProductsToCSV

pdf_generator = PDFGenerator.new('output.csv', 'your_pdf_file.pdf')
pdf_generator.generate_pdf
