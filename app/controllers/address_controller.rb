class AddressController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_address, only: %i[ edit update destroy set_default ]

  def index
    @addresses = Address.where("user_id = ? and archived_on is Null", current_user.id).order(:defaultaddress => :desc, :name => :asc)
  end

  def new
  end

  def edit
  end

  def set_default
    if @address
      olddefault = Address.where("user_id = ? and defaultaddress", current_user.id).first
      if olddefault
        olddefault.defaultaddress = false
        unless olddefault.save
          flash[:error] = olddefault.error.full_messages.join(", ")
        end
      end
      @address.defaultaddress = true
      unless @address.save
        flash[:error] = @address.error.full_messages.join(", ")
      end
    end
    redirect_to "/address"
  end

  def update
    @address.name = address_params[:name]
    @address.phonenumber = address_params[:phonenumber]
    @address.street = address_params[:street]
    @address.city = address_params[:city]
    @address.state = address_params[:state]
    @address.postal_code = address_params[:postal_code]
    unless @address.save
      flash[:error] = @address.error.full_messages.join(", ")
      redirect_to "/address"
    else
      redirect_to "/address"
    end
  end

  def create
    addressCount = @current_user.addresses.where("archived_on is Null").count
    unless (addressCount >= 10)
      address = Address.new(name: params[:name], phonenumber: params[:phonenumber], state: params[:state],
                            city: params[:city], postal_code: params[:postal_code], street: params[:street],
                            defaultaddress: false, user_id: current_user.id)
      unless address.save
        flash[:error] = address.errors.full_messages.join(", ")
        redirect_to new_address_path
      else
        redirect_to "/address"
      end
    else
      flash[:error] = "Your Address is exteed"
      redirect_to "/address"
    end
  end

  def destroy
    checkPendingOrders = @current_user.orders.where("address_id = ?", @address.id).first
    if checkPendingOrders.nil?
      @address.destroy
      flash[:success] = "Your address is deleted"
    else
      @address.archived_on = Time.zone.now
      if @address.save
        flash[:success] = "Your address is deleted"
      else
        flash[:error] = "Something went wrong"
      end
    end
    redirect_to "/address"
  end

  private

  def set_address
    @address = Address.where("user_id = ? and id = ? ", current_user.id, params[:id]).first
  end

  def address_params
    params.require(:address).permit(:name, :phonenumber, :state, :postal_code, :street, :city)
  end
end
