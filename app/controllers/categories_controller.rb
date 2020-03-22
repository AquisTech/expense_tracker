class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @categories = pagy(Category.all)
  end

  def new
    @category = Category.new
    render layout: false
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created.'
    else
      render_failure(@category)
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render_failure(@category)
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
