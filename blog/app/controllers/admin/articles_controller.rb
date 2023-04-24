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
    article = Article.find(params[:id])
    comments = article.comments.order(:created_at)
    file_path = Rails.root.join('public', "#{article.id}-#{article.title.parameterize}.pdf")
    if File.exist?(file_path)
      if (article.last_comment_deletion? && (article.last_comment_deletion > article.last_pdf_generated_at)) || (article.updated_at > article.last_pdf_generated_at) || (comments.present? && (comments.maximum(:updated_at) > article.last_pdf_generated_at))
        FileUtils.rm(file_path)
      end
    end
    if File.exist?(file_path)
        # Download last pdf in browser
        send_file file_path, type: 'application/pdf', disposition: 'attachment'
    else
      pdf = Prawn::Document.new
      pdf.text article.title, size: 24, style: :bold
      pdf.move_down 20
      pdf.text article.body
  
      pdf.move_down 20
      pdf.text "Comments", size: 18, style: :bold
      pdf.move_down 10
  
      comments.each do |comment|
        pdf.text "Comment by #{comment.commenter}", style: :italic
        pdf.text comment.body
        pdf.move_down 10
      end
      # Save new pdf and update last_pdf_generated_at
      pdf.render_file file_path
      article.update_column(:last_pdf_generated_at, Time.now)  
      # Download new pdf in browser
      send_file file_path, type: 'application/pdf', disposition: 'attachment'
    end
    # Check if last pdf generated at is nil or if there were any changes
  end
  

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end