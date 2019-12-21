class ArticlesController < ApplicationController
  def new
    @article = Article.new
  end

  def show
    @article = Article.find(params[:id])
  end
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to article_url(@article)
    else
      redirect_to new_article_url
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :description)
    end
end
