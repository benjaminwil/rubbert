class Tile
  BORDER_COLOUR = [0, 0, 0]
  BORDER_COLOUR_FOCUSED = [200, 200, 200]
  FILL_COLOUR = [90, 90, 90]
  FILL_COLOUR_FOCUSED = [150, 150, 150]
  LENGTH = 64

  attr_accessor :args, :cx, :cy, :x, :y, :w, :h

  def initialize(
    cursor_x:,
    cursor_y:,
    x: 0,
    y: 0
  )
    @cx = cursor_x
    @cy = cursor_y
    @x, @y, @w, @h = x, y, LENGTH, LENGTH
  end

  def render! args
    args.outputs.solids << ([x, y, LENGTH, LENGTH] + fill_colour)
    args.outputs.borders << ([x, y, LENGTH, LENGTH] + border_colour)
  end

  private

  def border_colour
    focused? ? BORDER_COLOUR_FOCUSED : BORDER_COLOUR
  end

  def fill_colour
    focused? ? FILL_COLOUR_FOCUSED : FILL_COLOUR
  end

  def focused?
    min_width, max_width = x, (x + w)
    min_height, max_height = y, (y + h)

    (min_width..max_width).to_a.include?(cx) &&
      (min_height..max_height).to_a.include?(cy)
  end
end

