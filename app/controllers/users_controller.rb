# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[edit update]

  def index
    user_friends = current_user.friends.pluck(:id)
    sent_requests = current_user.sent_requests.pluck(:friend_id)
    friend_requests = current_user.friend_requests.pluck(:user_id)
    user_ids = [user_friends, sent_requests, friend_requests, current_user.id].flatten
    @users = User.where.not(id: user_ids)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar, :email, :first_name, :last_name)
  end
end
