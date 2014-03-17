class AddDocumentToExpenses < ActiveRecord::Migration
  def change
  	add_column :expenses, :document_uid, :string
  	add_column :expenses, :document_name, :string
  end
end
