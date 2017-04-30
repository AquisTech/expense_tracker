class PaymentSourcesController < ApplicationController
  before_action :set_payment_source, only: [:show, :edit, :update, :destroy]

  # GET /payment_sources
  # GET /payment_sources.json
  def index
    @payment_sources = PaymentSource.all
  end

  # GET /payment_sources/1
  # GET /payment_sources/1.json
  def show
  end

  # GET /payment_sources/new
  def new
    @payment_source = PaymentSource.new
  end

  # GET /payment_sources/1/edit
  def edit
  end

  # POST /payment_sources
  # POST /payment_sources.json
  def create
    @payment_source = PaymentSource.new(payment_source_params)

    respond_to do |format|
      if @payment_source.save
        format.html { redirect_to @payment_source, notice: 'Payment source was successfully created.' }
        format.json { render :show, status: :created, location: @payment_source }
      else
        format.html { render :new }
        format.json { render json: @payment_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_sources/1
  # PATCH/PUT /payment_sources/1.json
  def update
    respond_to do |format|
      if @payment_source.update(payment_source_params)
        format.html { redirect_to @payment_source, notice: 'Payment source was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_source }
      else
        format.html { render :edit }
        format.json { render json: @payment_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_sources/1
  # DELETE /payment_sources/1.json
  def destroy
    @payment_source.destroy
    respond_to do |format|
      format.html { redirect_to payment_sources_url, notice: 'Payment source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_source
      @payment_source = PaymentSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_source_params
      params.fetch(:payment_source, {})
    end
end
