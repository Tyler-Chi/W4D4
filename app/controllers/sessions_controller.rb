


class SessionsController < ApplicationController
  #before you do this, run this method
  before_action :require_logged_in, only: [:destroy]
  # runs the require logged in method ONLY if the method is destroy.

  before_action :require_logged_out, only: [:new, :create]
  #runs the require_logged_out ONLY if the method is new or create

  def new
    render :new
  end

  def create
    user = User.find_by_credentials( params[:user][:username] , params[:user][:password] )
     #its gonna be hash within a hash!
    if user.nil?
       flash.now[:errors] = ["invalid user"]
       render :new
    else #we have a user
      login!(user)
      redirect_to cats_url
    end
  end

  def destroy #we are destroying the session token!@!@!@!@!@!@!
    logout!
    redirect_to new_session_url
  end

  #why dont we have to specify which class it is for logout?
  #because login/logout are inherited from the parent class ApplicationController

end
