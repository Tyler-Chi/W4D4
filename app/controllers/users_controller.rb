

class UsersController < ApplicationController

before_action :require_logged_out, only: [:new, :create]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save #at this point the save runs
      login!(@user)
      redirect_to cats_url #???????
    else
      flash.now[:errors] =  @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name,:password) #depends on what we call it in the form
  end


end
