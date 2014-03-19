class ExpensesController < ApplicationController
  layout 'col-md-8-offset-md-2', only: [:new, :edit, :show]
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)
    @expense.user_id = current_user.id
    
    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.json { render action: 'show', status: :created, location: @expense }
      else
        format.html { render action: 'new' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url }
      format.json { head :no_content }
    end
  end

  def import
    Expense.import(params[:file], current_user.id)
    redirect_to root_url, notice: "Expenses successfully imported!"
  end

  def dashboard
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:user_id, :date, :reseller, :item_or_service, :payment_form, :charged_to, :cost, :amount_from_budget, :notes, :document)
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end

    def sort_column
      Expense.column_names.include?(params[:sort]) ? params[:sort] : "date"
    end
end
