class ColumnsController < ApplicationController
  layout false
  before_action :find_column, only: [:update,:show]

  def update
    unless @column.update_attributes(column_params)
      flash[:error] = "Could not save formula"
    else
      flash[:info] = "Formula updated at column #{@column.position}."
    end
    redirect_to sheet_path(@column.sheet)
  end

  def show
  end

  def find_column
    @sheet = Sheet.find(params[:sheet_id])
    @column = @sheet.columns.where(position: params[:id].to_i).first
  end

  private
  def column_params
    { formula: params.require(:formula) }
  end
end
