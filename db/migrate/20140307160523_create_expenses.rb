class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :user_id
      t.string :date
      t.string :reseller
      t.string :item_or_service
      t.string :payment_form
      t.string :charged_to
      t.float :cost
      t.float :amount_from_budget
      t.text :notes

      t.timestamps
    end
  end
end
