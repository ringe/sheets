class Column < ActiveRecord::Base
  belongs_to :sheet
  has_many :cells, dependent: :destroy
  has_many :rows, through: :sheet

  after_initialize :set_content_type

  validates :sheet_id, presence: true
  validates_with ContentTypeValidator
  validates :position, numericality: { only_integer: true }

  after_save :create_cells

  default_scope {order(:position)}

  # Return the cell for a given row
  def cell_for_row(id)
    cells.find_or_create_by(row_id: id)
  end

  # Make sure there is a Cell for each Column
  def create_cells
    sheet.row_ids.each {|i| cell_for_row(i) }
  end

  # Return selector Class
  def selector
    eval(selector_class) rescue nil
  end

  # Return Array of selector options for selection classes
  def selections
    selector.send(selector_method) rescue nil
  end

  # Return a Cell by position on a Row or an attribute by name
  def [](attr_name)
    if attr_name.class == Fixnum
      cells.joins(:row).where(rows: {position: attr_name}).first
    else
      read_attribute(attr_name) { |n| missing_attribute(n, caller) }
    end
  end

  private

  # Default content type
  def set_content_type
    self.content_type ||= "string"
  end
end
