class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in

  def index
    render "index"
  end

  def new
    render "new"
  end

  def create
    name = params[:first_name] + " " + params[:last_name]
    email = params[:email]
    password = params[:password]
    roll = params[:roll] ? roll : "user"
    phonenumber = params[:phone]
    user = User.new(
      name: name,
      email: email,
      password: password,
      roll: roll,
      phonenumber: phonenumber,
    )
    if user.save
      session[:current_user_id] = user.id
      redirect_to "/"
    else
      flash[:error] = user.errors.full_messages.join(", ")
      redirect_to new_user_path
    end
  end
end
