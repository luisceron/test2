class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:index, :new, :create]

  def index
    @categories = index_object @user.categories, params
  end

  def show
  end

  def new
    @category = @user.categories.new
  end

  def edit
  end

  def create
    @category = @user.categories.new(category_params)
    save_object @category, {fem: true}
  end

  def update
    @category.assign_attributes(category_params)
    save_object @category, {fem: true}
  end

  def destroy
    destroy_object @category, user_categories_url(@user), {fem: true}
  end

  private
    def set_category
      @category = Category.find(params[:id])
      @user = @category.user
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def category_params
      params.require(:category).permit(:user_id, :name, :description)
    end
end
