class AddLastCommentDeletionToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :last_comment_deletion, :datetime
  end
end
