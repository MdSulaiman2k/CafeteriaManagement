class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in, :only => [:create, :new]
  before_action :set_user, only: %i[ edit show update destroy updateroll ]
  skip_before_action :verify_authenticity_token

  def index
    if current_user.roll != "admin"
      redirect_to error_path
    else
      @pagy, @users = pagy(User.where("roll = ? or roll = ?", "admin", "clerk").order(:roll, :id), items: 6)
      render "index"
    end
  end

  def show
  end

  def updateroll
    if current_user.roll != "admin"
      redirect_to error_path
    else
      if (@user.id == current_user.id)
        flash[:error] = "Not allowed to update own account"
      else
        @user.roll = params[:roll]
        unless @user.save
          flash[:error] = @user.errors.full_messages.join(", ")
        end
      end
      redirect_to "/users"
    end
  end

  def search
    if current_user.roll != "admin"
      redirect_to error_path
    else
      name = params[:name]
      unless name.nil?
        @pagy, @users = pagy(User.where("roll = ? or roll = ?", "admin", "clerk").where("lower(name)  Like '" + "#{name.downcase}%'").order(:id), items: 6)
      else
        @pagy, @users = pagy(User.where("roll = ? or roll = ?", "admin", "clerk").order(:id), items: 6)
      end
      render "index"
    end
  end

  def update
    if (current_user.id != @user.id)
      redirect_to error_path
    else
      if (@user.authenticate(user_params["password"]))
        unless (user_params["name"].nil?)
          @user.name = user_params["name"]
        end
        unless (user_params["email"].nil?)
          @user.email = user_params["email"]
        end
        unless (user_params["phonenumber"].nil?)
          @user.phonenumber = user_params["phonenumber"]
        end
        unless (user_params["newpassword"].nil?)
          @user.password = user_params["newpassword"]
        end
        unless @user.save
          flash[:error] = @user.errors.full_messages.join(", ")
        end
      else
        flash[:error] = "Incorrect Password"
      end
    end
    redirect_to "/users/#{@user.id}"
  end

  def new
    @current_user = current_user
    render "new"
  end

  def create
    name = params[:first_name] + " " + params[:last_name]
    email = params[:email]
    password = params[:password]
    roll = params[:roll] ? params[:roll] : "user"
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

  def edit
    if current_user.roll != "admin"
      redirect_to error_path
    else
      @user
    end
  end

  def destroy
    if current_user.roll != "admin"
      redirect_to error_path
    else
      if (@user.id == current_user.id)
        flash[:error] = "Not allowed to delete own account"
      else
        @user.destroy
      end
      redirect_to "/users"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :password, :email, :phonenumber, :newpassword)
  end
end
