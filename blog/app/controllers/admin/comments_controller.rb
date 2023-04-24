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
        update_last_comment_deletion
        redirect_to previous_path
    end

    private
        def update_last_comment_deletion
            @article.update(last_comment_deletion: Time.zone.now)
        end
end
