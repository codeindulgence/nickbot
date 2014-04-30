class Table

  # Parameters
  # width: Fixnum
  # height: Fixnum
  def initialize width, height
    @width = width
    @height = height
  end

  # No arguments
  # Returns String of format "<width>x<height>"
  def size
    "#{@width}x#{@height}"
  end

  # Accepts x and y coordinates
  # Returns coordinates array [x, y]
  # or nil if out of bounds
  def north_of x, y
    [x, y + 1] unless y + 1 == @height
  end

  # Accepts x and y coordinates
  # Returns coordinates array [x, y]
  # or nil if out of bounds
  def east_of x, y
    [x + 1, y] unless x + 1 == @width
  end

  # Accepts x and y coordinates
  # Returns coordinates array [x, y]
  # or nil if out of bounds
  def south_of x, y
    [x, y - 1] unless y - 1 < 0
  end

  # Accepts x and y coordinates
  # Returns coordinates array [x, y]
  # or nil if out of bounds
  def west_of x, y
    [x - 1, y] unless x - 1 < 0
  end
end
