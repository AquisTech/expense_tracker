class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :invite_member]

  def index
    @pagy, @groups = pagy(current_user.groups)
  end

  def new
    @group = current_user.group.new
    render layout: false
  end

  def create
    @group = current_user.groups.new(group_params)
    if @group.save
      redirect_to groups_path, notice: 'Group was successfully created.'
    else
      render_failure(@group)
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: 'Group was successfully updated.'
    else
      render_failure(@group)
    end
  end

  def destroy
    if @group.destroy
      redirect_to groups_path, notice: 'Group was successfully destroyed.'
    else
      redirect_to groups_path, notice: 'Group could not be destroyed.'
    end
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
      flash[:error] = 'User not found.'
      # TODO : Implement invitable and while joining join with group invitation
      # Implement this after friendlyId is implemented
      # Check if the link is opened by intended user, else create record with status as requested
    end
    redirect_to groups_path
  end

  private
    def set_group
      @group = current_user.groups.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name, :default)
    end
end
