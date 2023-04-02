class Tile
  LENGTH = 64
  SPRITES = { east: "sprites/east.png",
              top:  "sprites/top.png",
              west: "sprites/west.png" }

  attr_accessor :x, :y, :w, :h

  def initialize x: 0, y: 0, tile_size: LENGTH
    @x, @y, @w, @h = x, y, tile_size, tile_size
  end

  def render! args
    args.outputs.sprites << east_tile
    args.outputs.sprites << top_tile
    args.outputs.sprites << west_tile
  end

  private

  def east_tile
    x_pos, y_pos = x + U.center_point(w), y - U.center_point(h)
    [x_pos, y_pos, U.center_point(w), h, SPRITES.east]
  end

  def top_tile
    [x, y, w, h, SPRITES.top]
  end

  def west_tile
    x_pos, y_pos = x.to_i, y - U.center_point(h)
    [x_pos, y_pos, U.center_point(w), h, SPRITES.west]
  end
end

