PDFKit.configure do |config|
    config.wkhtmltopdf = '/home/HubertPiatkowski/.rvm/gems/ruby-3.0.0/bin/wkhtmltopdf' # Path to your wkhtmltopdf executable
    config.default_options = {
      :page_size => 'A4',
      :print_media_type => true
    }
end  