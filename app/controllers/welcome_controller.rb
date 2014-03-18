class WelcomeController < ApplicationController
  layout "col-md-8-offset-md-2", only: [:home]

  def home
  end
end
