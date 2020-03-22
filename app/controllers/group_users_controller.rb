class GroupUsersController < ApplicationController
  before_action :set_group_user, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @group_users = pagy(current_user.group_users)
  end

  def new
    @group_user = current_user.group_users.new
    render layout: false
  end

  def create
    @group_user = current_user.group_users.new(group_user_params)
    if @group_user.save
      redirect_to group_users_path, notice: 'Group user was successfully created.'
    else
      render_failure(@group_user)
    end
  end

  def update
    if @group_user.update(group_user_params)
      redirect_to group_users_path, notice: 'Group user was successfully updated.'
    else
      render_failure(@group_user)
    end
  end

  def destroy
    @group_user.destroy
    redirect_to group_users_path, notice: 'Group user was successfully destroyed.'
  end

  private
    def set_group_user
      @group_user = current_user.group_users.find(params[:id])
    end

    def group_user_params
      params.require(:group_user).permit(:user_id, :group_id)
    end
end
