require 'spec_helper'

describe "expenses/show" do
  before(:each) do
    @expense = assign(:expense, stub_model(Expense,
      :user_id => 1,
      :date => "Date",
      :reseller => "Reseller",
      :item_or_service => "Item Or Service",
      :payment_form => "Payment Form",
      :charged_to => "Charged To",
      :cost => 1.5,
      :amount_from_budget => 1.5,
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Date/)
    rendered.should match(/Reseller/)
    rendered.should match(/Item Or Service/)
    rendered.should match(/Payment Form/)
    rendered.should match(/Charged To/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/MyText/)
  end
end
