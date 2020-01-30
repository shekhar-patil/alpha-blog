class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  before_action :require_user, expect: %i[index show]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def show
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = 'Article was successfully created.'
      redirect_to article_url(@article)
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = 'Article was successfully updated.'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:danger] = @article.destroy ? 'Article deleted.' : 'Error while deleting the article.'
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description)
  end

  def require_same_user
    if current_user != @article.user
      flash[:danger] = 'You can only delete edit your articles.'
      redirect_to articles_path
    end
  end
end
