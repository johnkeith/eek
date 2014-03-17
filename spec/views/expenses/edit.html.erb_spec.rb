require 'spec_helper'

describe "expenses/edit" do
  before(:each) do
    @expense = assign(:expense, stub_model(Expense,
      :user_id => 1,
      :date => "MyString",
      :reseller => "MyString",
      :item_or_service => "MyString",
      :payment_form => "MyString",
      :charged_to => "MyString",
      :cost => 1.5,
      :amount_from_budget => 1.5,
      :notes => "MyText"
    ))
  end

  it "renders the edit expense form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", expense_path(@expense), "post" do
      assert_select "input#expense_user_id[name=?]", "expense[user_id]"
      assert_select "input#expense_date[name=?]", "expense[date]"
      assert_select "input#expense_reseller[name=?]", "expense[reseller]"
      assert_select "input#expense_item_or_service[name=?]", "expense[item_or_service]"
      assert_select "input#expense_payment_form[name=?]", "expense[payment_form]"
      assert_select "input#expense_charged_to[name=?]", "expense[charged_to]"
      assert_select "input#expense_cost[name=?]", "expense[cost]"
      assert_select "input#expense_amount_from_budget[name=?]", "expense[amount_from_budget]"
      assert_select "textarea#expense_notes[name=?]", "expense[notes]"
    end
  end
end
