class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :accept_membership, :decline_membership, :cancel_membership, :cancel_invitation, :block_membership, :transfer_ownership, :toggle_admin]

  def index
    @users = User.all
  end

  def new
    @user = User.new
    render layout: false
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render_failure(@user)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render_failure(@user)
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'User was successfully destroyed.'
    else
      redirect_to users_path, notice: 'User could not be destroyed.'
    end
  end

  def accept_membership
    if @user.join_group(Group.find(params[:group_id]))
      flash[:notice] = 'Group joined successfully'
    else
      flash[:error] = "Failed to join group. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def decline_membership
    if @user.decline_request(Group.find(params[:group_id]))
      flash[:notice] = 'Invitation declined successfully'
    else
      flash[:error] = "Failed to decline membership. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def cancel_membership
    if @user.exit_group(Group.find(params[:group_id]))
      flash[:notice] = 'Group left successfully'
    else
      flash[:error] = "Failed to leave group. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def remove_from_group
    if @user.exit_group(Group.find(params[:group_id]))
      flash[:notice] = 'User removed successfully'
    else
      flash[:error] = "Failed to remove user. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def cancel_invitation
    if @user.decline_request(Group.find(params[:group_id]))
      flash[:notice] = 'Invitation cancelled successfully'
    else
      flash[:error] = "Failed to cancel invitation. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def block_membership
    if @user.block_group(Group.find(params[:group_id]))
      flash[:notice] = 'Group blocked successfully'
    else
      flash[:error] = "Failed to block group. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def block_user
    if @user.block_group(Group.find(params[:group_id]))
      flash[:notice] = 'User blocked successfully'
    else
      flash[:error] = "Failed to block user. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def transfer_ownership # TODO: move to groups controller
    if @user.transfer_ownership(Group.find(params[:group_id]))
      flash[:notice] = 'Ownership transferred successfully'
    else
      flash[:error] = "Failed to transfer ownership. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  def toggle_admin
    if @user.toggle_admin(Group.find(params[:group_id]))
      flash[:notice] = 'Admin access toggled successfully'
    else
      flash[:error] = "Failed to toggle admin access. #{@user.errors.full_messages.to_sentence}"
    end
    redirect_to groups_path
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at)
    end
end
