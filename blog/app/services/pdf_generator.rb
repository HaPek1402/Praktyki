class PdfGenerator
    include ActionController::DataStreaming

    def initialize(article, comments, html)
        @article = article
        @comments = comments
        @html = html
    end

    def download
        @file_path = Rails.root.join('public', "#{@article.id}-#{@article.title.parameterize}.pdf")
        if File.exist?(@file_path)
            if (@article.last_comment_deletion? && (@article.last_comment_deletion > @article.last_pdf_generated_at)) || (@article.updated_at > @article.last_pdf_generated_at) || (@comments.present? && (@comments.maximum(:updated_at) > @article.last_pdf_generated_at))
                FileUtils.rm(@file_path)
            end
        end

        if File.exist?(@file_path) == false
            # Download last pdf in browser
            generate_new
        end
        @file_path
        # Check if last pdf generated at is nil or if there were any changes
    end

    def generate_new   
        pdf = PDFKit.new(@html, page_size: 'Letter').to_pdf
        File.open(@file_path, 'wb') do |file|
            file.write(pdf)
        end
        #config_pdf #that line only needs to be called when there were changes in configuration
        # Save new pdf and update last_pdf_generated_at
        @article.update_column(:last_pdf_generated_at, Time.now)
    end

    def config_pdf
        PDFKit.configure do |config|
            config.default_options = {}
        end

        PDFKit.configure do |config|
            config.default_options = {
            header_center: "My Blog",
            header_font_size: 48,
            footer_right: "Page [page] of [toPage]"
            }
        end
    end
end