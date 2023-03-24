class Player
  attr_accessor :state

  def initialize x: 0,
                 y: 0,
                 w: 32,
                 h: 32,
                 state: nil
    @state = state = {x: x, y: y, w: w, h: h}
  end

  def x=(number)
    state.x = number
  end

  def x
    state.x
  end

  def y=(number)
    state.y = number
  end

  def y
    state.y
  end

  def w
    state.w
  end

  def h
    state.h
  end

  def render! args
    args.outputs.primitives <<
      {
        primitive_marker: :sprite,
        path: "sprites/player.png",
        x: x,
        y: y,
        w: w,
        h: h,
        r: 100,
        g: 0,
        b: 200
      }
  end
end
