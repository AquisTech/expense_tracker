class OccurrencesController < ApplicationController
  before_action :set_occurrence, only: [:show, :edit, :update, :destroy]

  def index
    @pagy, @occurrences = pagy(current_user.occurrences)
  end

  def new
    @occurrence = current_user.occurrences.new
    render layout: false
  end

  def create
    @occurrence = current_user.occurrences.new(occurrence_params)
    if @occurrence.save
      redirect_to occurrences_url, notice: 'Occurrence was successfully created.'
    else
      render_failure(@occurrence)
    end
  end

  def edit
    render layout: false
  end

  def update
    if @occurrence.update(occurrence_params)
      redirect_to occurrences_url, notice: 'Occurrence was successfully updated.'
    else
      render_failure(@occurrence)
    end
  end

  def show
    render layout: false
  end

  def destroy
    @occurrence.destroy
    redirect_to occurrences_url, notice: 'Occurrence was successfully destroyed.'
  end

  private
    def set_occurrence
      @occurrence = current_user.occurrences.find(params[:id])
    end

    def occurrence_params
      params.require(:occurrence).permit(:recurrence_type, :interval, :days, :weeks, :months, :starts_on, :ends_on, :count, :recurrence_rule_id)
    end
end
