class Player
  attr_accessor :state

  SPRITES = { alive: "sprites/player/default.png",
              fallen: "sprites/player/fallen.png" }

  def initialize x: 0,
                 y: 0,
                 w: 32,
                 h: 32,
                 health: 1,
                 state: nil
    @state = state = { x: x,
                       y: y,
                       w: w,
                       h: h,
                       current_sprite: SPRITES.alive,
                       health: health }
  end

  def x=(number)
    return if fallen?

    state.x = number
  end

  def x
    state.x
  end

  def y=(number)
    return if fallen?

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

  def fallen!
    state.health = 0
    state.current_sprite = SPRITES.fallen
  end

  def fallen?
    state.health.zero?
  end

  def render! args
    args.outputs.primitives <<
      {
        primitive_marker: :sprite,
        path: state.current_sprite,
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
