class Admin::ArticlesController < ArticlesController
  before_action :authenticate_user!
  before_action :require_admin!

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to admin_article_path(@article)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to admin_article_path(@article)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to admin_articles_path, status: :see_other
  end

  def generate_pdf
    @article = Article.find(params[:id])
    @comments = @article.comments.order(:created_at)
    file_path = Rails.root.join('public', "#{@article.id}-#{@article.title.parameterize}.pdf")
    if File.exist?(file_path)
      if (@article.last_comment_deletion? && (@article.last_comment_deletion > @article.last_pdf_generated_at)) || (@article.updated_at > @article.last_pdf_generated_at) || (@comments.present? && (@comments.maximum(:updated_at) > @article.last_pdf_generated_at))
        FileUtils.rm(file_path)
      end
    end
    if File.exist?(file_path)
        # Download last pdf in browser
        send_file file_path, type: 'application/pdf', disposition: 'attachment'
    else
      html = render_to_string(action: :show)
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
      
      pdf = PDFKit.new(html, page_size: 'Letter').to_pdf
      File.open(file_path, 'wb') do |file|
        file.write(pdf)
      end
      send_data(pdf, filename: "#{@article.id}-#{@article.title.parameterize}.pdf", type: "application/pdf")
      # Save new pdf and update last_pdf_generated_at
      @article.update_column(:last_pdf_generated_at, Time.now)  
      # Download new pdf in browser
      #send_data pdf, filename: 'file_name.pdf', type: 'application/pdf', disposition: 'attachment'
    end
    # Check if last pdf generated at is nil or if there were any changes
  end
  

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
