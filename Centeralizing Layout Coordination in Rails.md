Centeralizing Layout Coordination in Rails

Cool charts with chartspreee

<div class="chart" style="height:500px;width:500px">
  <img src="http://api.chartspree.com/pie.svg?Available Funds=<%= "#{Configurable.total_budget.to_f - Expense.sum(:amount_from_budget)}" %>&Amount Spent=<%= "#{Expense.sum(:amount_from_budget)}" %>">
</div>
