require 'prawn'
require 'prawn/table'
require 'csv'
require 'net/http'

class PDFGenerator
  def initialize(csv_file_path, output_file_path)
    @csv_file_path = csv_file_path
    @output_file_path = output_file_path
    @table_data = []
    @downloaded_files = []
  end

  def generate_pdf
    csv_text = File.read(@csv_file_path)
    csv = CSV.parse(csv_text, headers: true)
    pdf = Prawn::Document.new
    @table_data << csv.headers[1..-1]
    counter = 1
    csv.each do |row|
      if row[1] =~ URI::regexp
        add_image_row(row, counter)
        counter += 1
      else
        add_row(row.fields)
      end
    end
    pdf.table(@table_data, header: true, column_widths: {0 => 120, 1 => 100, 2 => 75}) do |table|
      table.row(0).font_style = :bold
    end
    pdf.render_file(@output_file_path)
    @downloaded_files.each do |file|
      File.delete(file)
    end
  end

  private

  def add_row(row_data)
    @table_data << row_data
  end

  def add_image_row(row, counter)
    img_url = URI.extract(row[1])[0]
    uri = URI(img_url)
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      resp = http.get(uri.path)
      file_name = "#{counter}_#{File.basename(uri.path)}"
      File.open(file_name, 'wb') do |file|
        file.write(resp.body)
      end
      @downloaded_files << file_name
      @table_data << [{image: file_name, fit: [100, 100]}, row[2], row[3], row[4], row[5], row[6], row[7]]
    end
  end
end

pdf_generator = PDFGenerator.new('output.csv', 'your_pdf_file.pdf')
pdf_generator.generate_pdf