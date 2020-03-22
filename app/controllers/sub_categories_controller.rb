class SubCategoriesController < ApplicationController
  before_action :set_sub_category, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @sub_categories = pagy(SubCategory.all)
  end

  def new
    @sub_category = SubCategory.new
    render layout: false
  end

  def create
    @sub_category = SubCategory.new(sub_category_params)
    if @sub_category.save
      redirect_to sub_categories_path, notice: 'Sub category was successfully created.'
    else
      render_failure(@sub_category)
    end
  end

  def update
    if @sub_category.update(sub_category_params)
      redirect_to sub_categories_path, notice: 'Sub category was successfully updated.'
    else
      render_failure(@sub_category)
    end
  end

  def destroy
    @sub_category.destroy
    redirect_to sub_categories_path, notice: 'Sub category was successfully destroyed.'
  end

  private
    def set_sub_category
      @sub_category = SubCategory.find(params[:id])
    end

    def sub_category_params
      params.require(:sub_category).permit(:name, :category_id)
    end
end
