class ErrorController < ApplicationController
  def error
    render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end
end
