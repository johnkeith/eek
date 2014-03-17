require 'spec_helper'

describe "expenses/index" do
  before(:each) do
    assign(:expenses, [
      stub_model(Expense,
        :user_id => 1,
        :date => "Date",
        :reseller => "Reseller",
        :item_or_service => "Item Or Service",
        :payment_form => "Payment Form",
        :charged_to => "Charged To",
        :cost => 1.5,
        :amount_from_budget => 1.5,
        :notes => "MyText"
      ),
      stub_model(Expense,
        :user_id => 1,
        :date => "Date",
        :reseller => "Reseller",
        :item_or_service => "Item Or Service",
        :payment_form => "Payment Form",
        :charged_to => "Charged To",
        :cost => 1.5,
        :amount_from_budget => 1.5,
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of expenses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Date".to_s, :count => 2
    assert_select "tr>td", :text => "Reseller".to_s, :count => 2
    assert_select "tr>td", :text => "Item Or Service".to_s, :count => 2
    assert_select "tr>td", :text => "Payment Form".to_s, :count => 2
    assert_select "tr>td", :text => "Charged To".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
