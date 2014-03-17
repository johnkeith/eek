class Expense < ActiveRecord::Base
	belongs_to :user
	dragonfly_accessor :document

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
end
