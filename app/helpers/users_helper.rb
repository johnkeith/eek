module UsersHelper
  def sign_up_btn
    if User.sign_up_allowed == true
      "Prevent new account creation"
    else
      "Allow new account creation"
    end
  end
end
