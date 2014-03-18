class ApplicationController < ActionController::Base
  layout :layout_by_resource
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
  	expenses_path
  end

	def after_sign_out_path_for(resource)
	  root
	end

	protected

	def layout_by_resource
		if devise_controller?
			"col-md-4-offset-md-4"
		else
			"application"
		end
	end
end
