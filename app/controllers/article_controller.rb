class ArticleController < ApplicationController
  def index
    @category = params[:category]
  end

  def show
    @category = params[:category]
    @article_id = params[:id]
  end
end
