class Sheet < ActiveRecord::Base
  attr_accessor :column_count, :row_count, :no_logging

  has_many :columns, dependent: :destroy
  has_many :rows, dependent: :destroy

  after_save :create_columns, :create_rows

  def data
    rows.map(&:to_a).to_json
  end

  def no_logging
    @no_logging ||= false
  end

  def column_count
    @column_count ||= 2
  end

  def row_count
    @row_count ||= 2
  end

  # Add pos[:count] columns at position pos[:at]
  def add_column(pos)
    start = pos[:at].to_i
    count = pos[:count].to_i
    columns.each do |column|
      column.position += count if column.position >= start
    end
    count.times { columns.new(position: pos[:at]) }
    saved = columns.collect {|column| column.save }
    saved.all?
  end

  # Add pos[:count] rows at position pos[:at]
  def add_row(pos)
    start = pos[:at].to_i
    count = pos[:count].to_i
    rows.each do |row|
      row.position += count if row.position >= start
    end
    count.times { rows.new(position: pos[:at]) }
    saved = rows.collect {|row| row.save }
    saved.all?
  end

  # Move a column from pos[:from] to post[:dest]
  def move_column(pos)
    from = pos[:from].to_i
    dest = pos[:dest].to_i

    # Moving right
    if dest > from
      rws = columns.where(position: from..dest)
      rws.each do |col|
        if col.position == from
          moving = col
          moving.position = -1
        else
          col.position -= 1
        end
      end
      moving.position = dest

    # Moving left
    else
      rws = columns.where(position: dest..from)
      rws.each do |col|
        if col.position == from
          moving = col
          moving.position = -1
        else
          col.position += 1
        end
      end
      moving.position = dest
    end

    saved = rws.map(&:save)
    saved.all?
  end

  # Move a row from pos[:from] to post[:dest]
  def move_row(pos)
    from = pos[:from].to_i
    dest = pos[:dest].to_i

    # Moving down
    if dest > from
      rws = rows.where(position: from..dest)
      rws.each do |col|
        if col.position == from
          moving = col
          moving.position = -1
        else
          col.position -= 1
        end
      end
      moving.position = dest

    # Moving up
    else
      rws = rows.where(position: dest..from)
      rws.each do |col|
        if col.position == from
          moving = col
          moving.position = -1
        else
          col.position += 1
        end
      end
      moving.position = dest
    end

    saved = rws.map(&:save)
    saved.all?
  end

  # Remove pos[:count] columns at position pos[:at]
  def drop_column(pos)
    start = pos[:at].to_i
    count = pos[:count].to_i
    stop  = start + count - 1
    columns.where(position: start..stop).destroy_all
    columns.each_with_index do |column,i|
      column.position = i
      column.save
    end
  end

  # Remove pos[:count] rows at position pos[:at]
  def drop_row(pos)
    start = pos[:at].to_i
    count = pos[:count].to_i
    stop  = start + count - 1
    rows.where(position: start..stop).destroy_all
    rows.each_with_index do |row,i|
      row.position = i
      row.save
    end
  end

  # Update content of a Cell at the intersection of Row and Column
  def update_content(data)
    data.values.each do |change|
      row = change[0].to_i
      col = change[1].to_i
      cell = self[row][col]
      cell.content = change.last
      cell.save
    end
  end

  # Return Column headers, if set
  def column_headers
    use_column_headers ? columns.map(&:heading) : true
  end

  # Return Column headers, if set
  def row_headers
    use_row_headers ? rows.map(&:heading) : true
  end

  # Return a Row by position or an attribute by name
  def [](attr_name)
    if attr_name.class == Fixnum
      rows[attr_name]
    else
      read_attribute(attr_name) { |n| missing_attribute(n, caller) }
    end
  end

  private
  # Ensure the number of columns specified
  def create_columns
    (column_count.to_i - columns.size).times { columns.create(position: columns.size) }
  end

  # Ensure the number of rows specified
  def create_rows
    (row_count.to_i - rows.size).times { rows.create(position: rows.size) }
  end
end
