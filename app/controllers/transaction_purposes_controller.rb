class TransactionPurposesController < ApplicationController
  before_action :set_transaction_purpose, only: [:show, :edit, :update, :destroy]

  # GET /transaction_purposes
  # GET /transaction_purposes.json
  def index
    @transaction_purposes = TransactionPurpose.all
  end

  # GET /transaction_purposes/1
  # GET /transaction_purposes/1.json
  def show
  end

  # GET /transaction_purposes/new
  def new
    @transaction_purpose = TransactionPurpose.new
  end

  # GET /transaction_purposes/1/edit
  def edit
  end

  # POST /transaction_purposes
  # POST /transaction_purposes.json
  def create
    @transaction_purpose = TransactionPurpose.new(transaction_purpose_params)

    respond_to do |format|
      if @transaction_purpose.save
        format.html { redirect_to @transaction_purpose, notice: 'Transaction purpose was successfully created.' }
        format.json { render :show, status: :created, location: @transaction_purpose }
      else
        format.html { render :new }
        format.json { render json: @transaction_purpose.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_purposes/1
  # PATCH/PUT /transaction_purposes/1.json
  def update
    respond_to do |format|
      if @transaction_purpose.update(transaction_purpose_params)
        format.html { redirect_to @transaction_purpose, notice: 'Transaction purpose was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction_purpose }
      else
        format.html { render :edit }
        format.json { render json: @transaction_purpose.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_purposes/1
  # DELETE /transaction_purposes/1.json
  def destroy
    @transaction_purpose.destroy
    respond_to do |format|
      format.html { redirect_to transaction_purposes_url, notice: 'Transaction purpose was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_purpose
      @transaction_purpose = TransactionPurpose.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_purpose_params
      params.fetch(:transaction_purpose, {})
    end
end
