class Sheet < ActiveRecord::Base
  has_many :columns
  has_many :rows
end
