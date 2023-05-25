class ArticlesController < ApplicationController
  def index
    @articles = Article.paginate(page: params[:page], per_page: 10)
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments.paginate(page: params[:page], per_page: 10)
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end