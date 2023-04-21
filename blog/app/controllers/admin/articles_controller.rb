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
      redirect_to @article
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

    file_path = Rails.root.join('public', "#{article.title.parameterize}.pdf")
    pdf.render_file file_path

    redirect_to admin_article_path(article), notice: "PDF saved successfully!"
  end
  
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
