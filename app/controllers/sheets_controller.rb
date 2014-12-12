class SheetsController < ApplicationController
  before_action :set_sheet, only: [:show, :edit, :update, :destroy]

  def index
    @sheet = Sheet.new
    @sheets = Sheet.all
  end

  def show
  end

  def new
    redirect_to sheets_path
  end

  # POST /sheets
  def create
    sheet = params[:sheet][:sheet]
    params[:sheet].delete("sheet")

    if sheet
      if sheet.original_filename[/xls$/]
        if libreoffice_available?
          system "libreoffice --headless --convert-to xlsx #{sheet.tempfile.path} --outdir tmp"
          path = sheet.tempfile.path[1..-1] + ".xlsx"
        else
          flash[:error] = "Can't import MS Excel files without headless LibreOffice."
        end
      end
      if sheet.original_filename[/xlsx$/]
        path = sheet.tempfile.path
      end
      x = RubyXL::Parser.parse(path) if path
    end

    if x
      sheets = []
      x.sheets.each_with_index do |xsheet,xno|
        sheet = Sheet.new(name: xsheet.name, no_logging: true)
        sheets << sheet

        xrows = x[xno].sheet_data.rows

        sheet.row_count     = xrows.size
        sheet.column_count  = xrows.map(&:cells).map(&:size).sort.last
        sheet.save

        xrows.map(&:cells).each_with_index do |xrow,row|
          xrow.each_with_index do |cell,col|
            val = cell.value rescue nil
            unless val.blank?
              cell = sheet[row][col]
              cell.content = val
              cell.save
            end
          end
        end
      end
      redirect_to sheets_path, notice: "Sheets created: " + sheets.map(&:name).join(", ")
    else
      @sheet = Sheet.new(sheet_params)
      if @sheet.save
        redirect_to @sheet, notice: 'Sheet was successfully created.'
      else
        render :index
      end
    end
  end

  def edit
    binding.pry
  end

  # PUT /sheets/1
  # PUT /sheets/1.json
  def update
    @sheet.add_row(count_params) if params[:change] == "add_row"
    @sheet.add_column(count_params) if params[:change] == "add_column"
    @sheet.move_row(move_params) if params[:change] == "move_row"
    @sheet.move_column(move_params) if params[:change] == "move_column"
    @sheet.drop_row(count_params) if params[:change] == "drop_row"
    @sheet.drop_column(count_params) if params[:change] == "drop_column"

    @sheet.update_content(content_params) if params[:change] == "content"

    @sheet.update_attributes(sheet_params) if params[:sheet]

    respond_to do |format|
      if @sheet.save
        format.html { redirect_to @sheet, notice: 'Sheet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sheet
      @sheet = Sheet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sheet_params
      params.require(:sheet).permit(:name, :column_count, :row_count)
    end

    def libreoffice_available?
      system("which libreoffice > /dev/null") && !system("ps ax | grep -v grep | grep libreoffice > /dev/null")
    end

    def move_params
      params.permit(:from, :dest)
    end

    def count_params
      params.permit(:at, :count)
    end

    def content_params
      params.require(:data)
    end
end
