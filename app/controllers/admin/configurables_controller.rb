class Admin::ConfigurablesController < ApplicationController
	include ConfigurableEngine::ConfigurablesController
	layout 'col-md-8-offset-md-2'
end
