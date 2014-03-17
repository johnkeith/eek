class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    redirect_to root_url unless current_user && current_user.admin?
  end

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    if @user.destroy
        redirect_to root_url, notice: "User deleted."
    end
  end  
end
