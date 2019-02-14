class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
    render layout: false
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_url, notice: 'Group was successfully created.'
    else
      render_failure(@group)
    end
  end

  def edit
    render layout: false
  end

  def update
    if @group.update(group_params)
      redirect_to groups_url, notice: 'Group was successfully updated.'
    else
      render_failure(@group)
    end
  end

  def show
    render layout: false
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :default)
    end
end
