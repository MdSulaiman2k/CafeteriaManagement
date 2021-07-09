class UsersController < ApplicationController
  skip_before_action :ensure_user_logged_in, :only => [:create, :new]
  before_action :ensure_admin_in, :only => [:index, :updateroll, :search]
  before_action :set_user, only: %i[ edit update destroy updateroll ]

  def index
    @pagy, @users = pagy(User.where("archived_on is NULL").order(:name, :id), items: 10)
  end

  def show
    if current_user.id == Integer(params[:id])
      set_user
    else
      redirect_to error_path
    end
  end

  def updateroll
    if (@user.id == current_user.id)
      flash[:error] = "Not allowed to update"
    else
      @user.roll = params[:roll]
      unless @user.save(validate: false)
        flash[:error] = @user.errors.full_messages.join(", ")
      end
    end
    redirect_back(fallback_location: "/")
  end

  def search
    name = params[:name]
    @search_category = params[:search]
    if ((@search_category == "id"))
      begin
        id = Integer(name)
        @pagy, @users = pagy(User.where("id = ? and archived_on is NULL", name))
      rescue
        flash[:error] = "Enter valid input"
      end
    else
      @pagy, @users = pagy(User.where("lower(#{@search_category})  Like '" + "#{name.downcase}%' and archived_on is NULL").order(:name, :id), items: 10)
    end
    render "index"
  end

  def update
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
      @user.password = user_params["password"]
      unless (user_params["newpassword"].nil?)
        @user.password = user_params["newpassword"]
      end
      unless @user.save
        flash[:error] = @user.errors.full_messages.join(", ")
      end
    else
      flash[:error] = "Incorrect Password"
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
      if current_user && current_user.roll == "admin"
        redirect_to "/users"
      else
        session[:current_user_id] = user.id
        redirect_to "/"
      end
    else
      flash[:error] = user.errors.full_messages.join(", ")
      redirect_back(fallback_location: "/")
    end
  end

  def destroy
    if @user.id == 1
      flash[:error] = "You not able to delete the super admin"
      redirect_back(fallback_location: "/") and return
    end
    orderPending = @user.orders.where("delivered_at is NULL")
    if orderPending.empty?
      if (@user.id == current_user.id)
        if (@user.authenticate(params[:password]))
          @user.archived_on = Time.zone.now
          @user.save(validate: false)
          session[:current_user_id] = nil
          @current_user = nil
          redirect_to "/"
        else
          flash[:error] = "Incorrect Password"
          redirect_to "/users/#{current_user.id}"
        end
      elsif (current_user.roll == "admin")
        @user.archived_on = Time.zone.now
        unless @user.save(validate: false)
          flash[:error] = @user.errors.full_messages.join(", ")
        end
        redirect_to "/users"
      else
        redirect_to error_path
      end
    else
      flash[:error] = "User Have Pending Orders"
      redirect_back(fallback_location: "/")
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
