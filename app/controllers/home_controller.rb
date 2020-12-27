class HomeController < ApplicationController
  def index
    render plain: "Homepage! POD_NAME: #{ENV['POD_NAME']}; POD_IP: #{ENV['POD_IP']}"
  end

  def secrets
    render html: view_context.debug(Rails.application.credentials.config)
  end
end
