class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :expenses
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :set_initial_admin

  private 
  	def set_initial_admin
  		if User.count == 1
  			User.first.update_attribute :admin, true
      else
  			return true
  		end
  	end
end
