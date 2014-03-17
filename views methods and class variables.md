views methods and class variables

http://stackoverflow.com/questions/12590723/what-is-the-proper-way-to-access-class-variables-in-ruby-1-9
http://apidock.com/rails/Class/cattr_accessor

I wanted to give my admin user the ability to disallow sign ups in the app if they choose to do so - i.e., if all the cool cats have signed up and you want to keep out the rest of the riff raff. 

To do so, I set up a class variable and then a method in my UsersController, then a button on my User Index View (which will be only accessible for the admin user) and then a button

user.rb
cattr_accessor :sign_up_allowed
@@sign_up_allowed = true

users_controller.rb
def disallow_sign_up
  User.sign_up_allowed ? User.sign_up_allowed = false : User.sign_up_allowed = true
  redirect_to users_index_path
end

users/index.html.erb
<%= button_to "Turn off sign-up", action: "disallow_sign_up" %>

disallow_sign_up.html.erb
## it is blank, but had to make it....

routes.rb
resources :users do
  collection { post :disallow_sign_up }
end

finally, wrapped my devise sign up in a conditional to check if it is allowed

<% if User.sign_up_allowed %>
<h2>Sign up</h2>

<%= form_for(resource, :as => resource_name, :url => registration_path(resource_name)) do |f| %>
  <%= devise_error_messages! %>
	
	<% if User.all == [] %>
		<div>Welcome! You are the first user of this app and so we are going to make you the administrator.</div>
	<% end %>

  <div><%= f.label :email %><br />
  <%= f.email_field :email, :autofocus => true %></div>

  <div><%= f.label :password %><br />
  <%= f.password_field :password %></div>

  <div><%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation %></div>

  <div><%= f.submit "Sign up" %></div>
<% end %>

<%= render "devise/shared/links" %>
<% else %>

<p>Sign ups are not allowed at this time. Thanks for stopping by!</p>

<% end %> 
