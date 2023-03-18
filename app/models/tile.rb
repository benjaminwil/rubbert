class Tile
  LENGTH = 64
  SPRITES = { east: "sprites/east.png",
              top:  "sprites/top.png",
              west: "sprites/west.png" }

  attr_accessor :cx,
                :cy,
                :x,
                :y,
                :w,
                :h

  def initialize cursor_x:,
                 cursor_y:,
                 x: 0,
                 y: 0
    @cx = cursor_x
    @cy = cursor_y
    @x, @y, @w, @h = x, y, LENGTH, LENGTH
  end

  def render! args
    args.outputs.sprites << east_tile
    args.outputs.sprites << top_tile
    args.outputs.sprites << west_tile
  end

  private

  def east_tile
    x_pos, y_pos = x + U.center_point(LENGTH), y - U.center_point(LENGTH)
    [x_pos, y_pos, U.center_point(LENGTH), LENGTH, SPRITES.east]
  end

  def top_tile
    [x, y, LENGTH, LENGTH, SPRITES.top]
  end

  def west_tile
    x_pos, y_pos = x.to_i, y - U.center_point(LENGTH)
    [x_pos, y_pos, U.center_point(LENGTH), LENGTH, SPRITES.west]
  end
end

