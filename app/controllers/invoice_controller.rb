class InvoiceController < ApplicationController
  before_action :ensure_admin_in

  def index
    @dayTotal = Order.where("status != 'cancel'").where(order_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).sum(:totalvalue)
    @weekTotal = Order.where("status != 'cancel' and order_at >=? and order_at<=?", DateTime.now().beginning_of_week - 1.weeks, DateTime.now()).sum(:totalvalue)
    @monthTotal = Order.where("status != 'cancel' and order_at >=? and order_at<=?", DateTime.now().beginning_of_month - 1.months, DateTime.now()).sum(:totalvalue)
    @yearTotal = Order.where("status != 'cancel' and order_at >=? and order_at<=?", DateTime.now().beginning_of_year - 1.years, DateTime.now()).sum(:totalvalue)
    @overAll = Order.where("status != 'cancel'").sum(:totalvalue)
    @highestsale = Order.where("status != 'cancel'").maximum(:totalvalue)
  end
end
