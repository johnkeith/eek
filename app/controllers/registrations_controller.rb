class RegistrationsController < Devise::RegistrationsController
	def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
	end

	def after_sign_in_path_for(resource)
		if User.count == 1 
    	admin_configurable_path
    else
    	dashboard_expenses_path
    end
  end
end