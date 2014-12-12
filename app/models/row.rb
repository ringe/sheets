class Row < ActiveRecord::Base
  belongs_to :sheet
  has_many :cells, dependent: :destroy
  has_many :columns, through: :sheet

  has_many :row_changes

  validates :sheet_id, presence: true
  validates :position, numericality: { only_integer: true }

  after_save :save_row_change, :create_cells

  default_scope {order(:position)}

  def to_json
    { row: { id: id, updated_at: updated_at, cells: to_a } }.to_json
  end

  # Return row as array
  def to_a
    cells.map(&:to_s)
  end

  # Return the cell for a given row
  def cell_for_column(id)
    cells.find_or_create_by(column_id: id)
  end

  # Make sure there is a Cell for each Column
  def create_cells
    sheet.column_ids.each {|i| cell_for_column(i) }
  end

  # Save row change for logging purposes
  def save_row_change
    return true if sheet.no_logging
    if row_changes.empty? or json_diff
      row_changes.create(row_id: id, json: to_json)
    end
  end

  # Return a Cell by position on a Column or an attribute by name
  def [](attr_name)
    if attr_name.class == Fixnum
      cells.joins(:column).where(columns: {position: attr_name}).first
    else
      read_attribute(attr_name) { |n| missing_attribute(n, caller) }
    end
  end

  def last_change
    row_changes.last.updated_at rescue updated_at
  end

  private
  def json_diff
    JSON.parse(row_changes.last.json)["row"]["cells"] != JSON.parse(to_json)["row"]["cells"]
  end
end
