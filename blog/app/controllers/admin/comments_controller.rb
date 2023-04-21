class Admin::CommentsController < CommentsController
    before_action :require_admin!
    def index
        @article = Article.find(params[:article_id])
        @comments = @article.comments
    end
    def destroy
        @article = Article.find(params[:article_id])
        @comment = @article.comments.find(params[:id])
        @comment.destroy
        redirect_to previous_path
    end
end
