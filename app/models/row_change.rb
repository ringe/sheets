class RowChange < ActiveRecord::Base
  belongs_to :row

  before_save :validate_diff

  def validate_diff
    return true if row.row_changes.empty?
    if JSON.parse(row.row_changes.last.json)["row"]["cells"] == JSON.parse(json)["row"]["cells"]
      errors.add(:row, "no difference since last change")
    end
  end
end
