class AddLastPdfGeneratedAtToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :last_pdf_generated_at, :datetime
  end
end
