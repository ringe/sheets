class Cell < ActiveRecord::Base
  belongs_to :row
  belongs_to :column
end
