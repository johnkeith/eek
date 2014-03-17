$ rails new trackexpenses --skip-test-unit

create proper gemfile (using same as tomove app + some additions from Hartl)

$ bundle install

Replace secret_token.rb with Hartl method

Replace gitignore with included code

$ rails generate rspec:install

$ rails generate devise:install

$ rails generate devise User

$ rake db:migrate

$ rails generate devise:views

$ rails generate controller welcome home --no-test-framework

$ rails generate scaffold Expense user_id:integer date:str
ing reseller:string item_or_service:string payment_form:string charged_to:string cost:float amount_from_budget:float notes:text

$ rake db:migrate

Add sign up and create account links to root (home) page

<%= link_to 'Create an account', new_user_registration_path, class: "btn btn-default btn-lrg" %>
<%= link_to 'Sign in', new_user_session_path, class: 'btn btn-default btn-lrg' %>

Add bootstrap to application.css and change extension to add scss. Also add main contain to css and then wrap the default layout with it

-application.css.scss
@import 'bootstrap';
.main-contain {
      margin:50 auto;
      max-width:960px;
}

-application.html.erb

<div class="main-contain">
     <%= yield %>
</div>

Add notices and alerts to application.html before yield. Also, create a _navbar.html.erb partial in the layouts folder and add a 
          <%= render 'navbar' %>
          <p class="notice"><%= notice %></p>
          <p class="alert"><%= alert %></p>

In the _navbar partial

<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
     <div class="container-fluid">
          <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="/">ExpenseTracking</a>
  </div>

       <!-- Collect the nav links, forms, and other content for toggling -->
  <div class="collapse navbar-collapse">
    <ul class="nav navbar-nav navbar-right">
         <% if user_signed_in? %>
      <% else %>
           <li><%= link_to "Create account", new_user_registration_path %></li>
           <li><%= link_to "Sign in", new_user_session_path %></li>
      <% end %>
    </ul>
     </div>
</nav>

In the application_controller.rb in order to send signed in users to the main expenses page

  def after_sign_in_path_for(resource)
       expenses_path
  end

Add bootstrap classes to expenses table and add classes to button at bottom

<table class="table table-striped">

...

<%= link_to 'New Expense', new_expense_path, class: 'btn btn-primary btn-large' %>

comment out entire scaffolds.css.scss

add bootstrap form gem to gemfile and bundle install in order to make form styling easier

gem 'bootstrap_form'

$ bundle install

application.css

//= require rails_bootstrap_forms

NEED TO GET FORMS WORKING!

GOT FORM WORKING

The bootstrap_form gem needs you to manually insert a rails_bootstrap_form.css sheet in the app/assets/stylesheets folder in order to process properly. That file contains the following css


.rails-bootstrap-forms-date-select,
.rails-bootstrap-forms-time-select,
.rails-bootstrap-forms-datetime-select {
  select {
    display: inline-block;
    width: auto;
  }
}
.rails-bootstrap-forms-error-summary {
  margin-top: 10px;
}

Fixed a problem with the bootstrap_form gem - see master list of gem changes for full explanation

Then, removed User_ID field from the create expense form, as this needs to be passed through the params

{% comment %}
  <div class="field">
    <%= f.label :user_id %><br>
    <%= f.number_field :user_id %>
  </div>
 {% endcomment %}

In the expenses_controller.rb, add a before_filter per the devise documentation to ensure that unregistered/logged in users cannot access these urls wontonly.

  before_filter :authenticate_user!

Not sure if this is the proper way to do it, but add a hidden_field with user_id in the _form

  <%= f.hidden_field :user_id %>

Then add this to the def create method in controller

    @expense.user_id = current_user.id

Again, not sure about the safety of above.

It may be a little premature, but I added a file_field to the _form for expenses I’ll need to go add that to the database with a migration

<%= f.file_field :file %>

gemfile
gem ‘paperclip’

bundle install

create_documents migration

  def change
    create_table :documents do |t|
         t.integer :user_id
      t.timestamps
    end

    add_index :documents, :user_id
    add_attachment :documents, :add_attachment
    add_column :expenses, :document_id, :integer
  end

rake db:migrate

why in the treehouse example does the document belong to the Status model? Could it be the other way around? I am going to try in the document.rb model to do it the other way

belongs_to :expense

expense.rb

has_one :document

None of the highlighted above worked. I need to try using this tomorrow: http://guides.rubyonrails.org/form_helpers.html#uploading-files and see where that can take me. The problem is twofold - 1) my bootstrap_form gem isn’t compatable with nested forms and 2) the tuts I have found want me to create a separate document model to handle my uploads.

What if I want to make the documents part of my expenses model? How could that be done?

Add dragonfly to gemfile

gem 'dragonfly', "~>1.0.3"

bundle

Add accessor to expense.rb

dragonfly_accessor :document

Create AddDocumentToExpenses migration

rails g migration AddDocumentToExpenses

class AddDocumentToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :document_uid, :string
    add_column :expenses, :document_name, :string
  end
end

rake db:migrate

Format _form.html.erb for expenses to include

  <div class="field">
    <%= f.label :document %><br>
    <%= f.file_field :document %>
  </div>

Make sure expenses_controller responds to :document param

def expense_params
      params.require(:expense).permit(:user_id, :date, :reseller, :item_or_service, :payment_form, :charged_to, :cost, :amount_from_budget, :notes, :document)
    end

Then, under config/initializers/dragonfly.rb set the default location for data storage - in order for the files not to just be shoved in the public directory. I changed it to a directory called secure_storage

Add file link to show view (the root_url.chop is hacky, needs to be cleaned up)

<p>
  <strong>Document:</strong>
  <%= link_to "File", root_url.chop + @expense.document.url %>
</p>

_navbar

 <li><%= link_to 'Show all expenses', expenses_path %></li>

Adding view and method to view controller to deal with an uploaded CSV file 

def import
  end

in view import.html.erb

watch this and then write code for import method
http://railscasts.com/episodes/396-importing-csv-and-excel?view=asciicast

expenses/index

<h2>Import Expenses</h2>
<%= form_tag import_expenses_path, multipart: true do %>
  <%= file_field_tag :file %>
  <%= submit_tag "Import" %>
<% end %>

routes.rb

 authenticated :user do
    root :to => 'expenses#index', as => "authenticated_root"
  end  
  root :to => 'welcome#home'
  
  devise_for :users
  resources :expenses do
    collection { post :import }
  end

expenses_controller

  def import
    Expense.import(params[:file], current_user.id)
    redirect_to root_url, notice: "Expenses successfully imported!"
  end

expenses.rb

def self.import(file, user_id)
    contents = CSV.open file.path, headers: true, header_converters: :symbol, converters: :numeric
    contents.each do |row|
      Expense.create date: row[:date], 
                     reseller: row[:reseller],
                     item_or_service: row[:item_or_service],
                     payment_form: row[:payment_form],
                     charged_to: row[:charged_to], 
                     cost: row[:cost],
                     amount_from_budget: row[:amount_from_budget], 
                     notes: row[:notes], 
                    user_id: user_id
    end
  end

  application.rb

require 'CSV'

Easily delete unnecessary records in database - Expense.delete_all 

expenses/show.html.erb

<% if @expense.document %>
<p>
  <strong>Document:</strong>
  <%= link_to "File", root_url.chop + @expense.document.url %>
</p>
<% end %>

Had the damndest time getting current_user.id into the import so that the creator would be assigned. That said ,I google and here http://stackoverflow.com/questions/14331972/passing-a-parameter-when-uploading-csv-files-and-parsing-to-database-rails was the answer I was looking for. went back and changed teh code above

Next: adding sorting , read through to the bottom of below for full instructions
http://railscasts.com/episodes/228-sortable-table-columns?view=asciicast

adding admin role

rails generate migration add_admin_to_users admin:boolean

migration code

class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :admin
  end
end

rake db:migrate

got deleting done! (haven't finished implementing admin controls, need to look into cancan) 
http://stackoverflow.com/questions/16289299/rails-how-to-destroy-users-created-under-devise

also created a view and controller for users which allows anyone (currently) to see all registered users

Struggling with ways of making a user an admin. Think I am going to do it in a Rake method, after reading many places in SO that point out this is the safest way. That means, only someone with root access to the application and knowledge of the rake command would be able to create an admin
This didn't work in the registrations_controller.rb that I created

def make_admin
    User.first.update_attribute :admin, true
    puts "this method ran"
  end

  def after_sign_up_path_for(resource)
    make_admin if User.all == []
    after_sign_in_path_for(resource)
  end
end

This did, however, work. 

http://stackoverflow.com/questions/11557609/how-to-make-first-user-became-admin-in-devise-gem

created a modal for the 



migration to create read-write rights for users

class AddReadWriteToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :read_right, :boolean, default: true
    add_column :users, :write_right, :boolean, default: true
  end

  def self.down
    remove_column :users, :read_right
    remove_column :users, :write_right
  end
end

adding paginiation to index view of expenses (http://ruby.railstutorial.org/chapters/updating-showing-and-deleting-users#sec-pagination)
 gemfile

 gem 'will_paginate'
gem 'bootstrap-will_paginate'

bundle install

expenses/index.html.erb

<%= will_paginate %>
  <tbody>
    <% @expenses.each do |expense| %>
      <tr>
        <td><%= expense.user_id %></td>
        <td><%= expense.date %></td>
        <td><%= expense.reseller %></td>
        <td><%= expense.item_or_service %></td>
        <td><%= expense.payment_form %></td>
        <td><%= expense.charged_to %></td>
        <td><%= expense.cost %></td>
        <td><%= expense.amount_from_budget %></td>
        <td><%= expense.notes %></td>
        <td><%= link_to 'Show', expense %></td>
        <td><%= link_to 'Edit', edit_expense_path(expense) %></td>
        <td><%= link_to 'Destroy', expense, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
  <%= will_paginate %>

expenses controller

def index
    @expenses = Expense.order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
  end

  easy easy easy.

show total spent:

Active record comes with calculations methdos
http://apidock.com/rails/ActiveRecord/Calculations/ClassMethods/count

I added this to my expenses/index and it displayed without issue.
<%= "The total amount spend from budget so far is #{Expense.sum(:amount_from_budget)}" %>

Now I need a total budget to compare that to

in expense.rb
  cattr_accessor :total_budget
  @@total_budget = 0

In users/index.html.erb

Yuck, not working. 


Above until 414 was junk. Here's the new approach

https://github.com/paulca/configurable_engine

I am going to try to add it through a gem, though it seems like this is not necessarily something that needs a gem...

I will write where I deviate from the instructions on the site. Then I will need to go and remove the configurations I have placed in the app thus far. 

Removing old configuration for allowing signup 

1) disallow signup method in users_controller.rb

2) remove signup allowed class variable and cattr_accessor from user.rb
adding dashboard view for root url
3) remove buttons from users/index.html.erb
4) redo devise/registrations/new to reference configurable instead of above class variable

<% if Configurable.allow_user_signup %>

dealing with admin signup redirect


  def after_sign_in_path_for(resource)
    if User.count == 1 
      admin_configurable_path
    else
      dashboard_expenses_path
    end
  end

  NEED TO ADD NOTICE
