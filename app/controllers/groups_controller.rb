class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :invite_member]

  def index
    @groups = current_user.groups
  end

  def new
    @group = current_user.group.new
    render layout: false
  end

  def create
    @group = current_user.groups.new(group_params)
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

  def invite_member
    user = User.search(params[:search_term])
    if user
      if @group.invite(user)
        flash[:notice] = 'Member invited successfully'
      else
        flash[:error] = "Failed to invite member. #{@group.errors.full_messages.to_sentence}"
      end
    else
      flash[:error] = 'User not found.' # TODO : Implement invitable and while joining join with group invitation
    end
    redirect_to groups_url
  end

  private
    def set_group
      @group = current_user.groups.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :default)
    end
end
