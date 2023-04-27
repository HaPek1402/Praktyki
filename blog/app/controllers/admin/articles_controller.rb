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
    html = render_to_string(action: :show)
    pdf_generator = PdfGenerator.new(@article, @comments, html)
    file = pdf_generator.download
    send_file file, type: 'application/pdf', disposition: 'attachment'
  end
  
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
