class Admin::ConfigurablesController < ApplicationController
	before_filter :authenticate_user!
  before_filter do
    redirect_to root_url unless current_user.admin?
  end
  include ConfigurableEngine::ConfigurablesController
	layout 'col-md-8-offset-md-2'
end
