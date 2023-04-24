class CommentsController < ApplicationController
    before_action :authenticate_user!
    def create
        @article = Article.find(params[:article_id])
        @comment = @article.comments.create(comment_params)
        redirect_to previous_path
    end
    private
        def comment_params
            params.require(:comment).permit(:commenter, :body, :status)
        end

        def previous_path
            referer = request.referer
            if referer.include?('admin')
              referer
            else
              article_path(@article)
            end
        end
end
