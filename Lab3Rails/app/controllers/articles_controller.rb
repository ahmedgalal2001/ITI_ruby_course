class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :report]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.where(archived: nil)
  end

  def show
  end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, status: :see_other, notice: 'Article was successfully destroyed.'
  end

  def report
    @article.increment!(:reports_count)
    if @article.reports_count >= 6
      @article.update(archived: true)
    end
    redirect_to articles_path, notice: 'Article was reported.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :image)
  end

  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    redirect_to articles_path, notice: 'Not authorized to edit this article' if @article.nil?
  end
end
