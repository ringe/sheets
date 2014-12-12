# Cell
#
# The Cell class is the model that stores actual data.
#
# See all "Cell types" at http://handsontable.com/demo/numeric.html
#
# => The string type is the default data type.
#
# Types are stored as follows:
#
#   HOT type      Cell field      Rails type
#   string        string_value    string
#   numeric       numeric_value   float
#   date          date_value      date
#   checkbox      checkbox_value  boolean
#   select        string_value    string
#   dropdown      string_value    string
#   autocomplete  string_value    string
#
# Which type to use for a cell is set per Column.
#
class Cell < ActiveRecord::Base
  belongs_to :row
  belongs_to :column
  has_one :sheet, through: :row

#  before_validation :store_content
  validates :column_id, :row_id, numericality: { only_integer: true, greater_than: 0 }
  after_save :save_row_change

#  default_scope {joins(:column).order(column)}

  def to_s
    content.to_s
  end

  # Save the row when the cell changes
  def save_row_change
    row.updated_at = Time.now
    row.save
  end

  # Return position [ row, column]
  def position
    [row.position, column.position]
  end
end
