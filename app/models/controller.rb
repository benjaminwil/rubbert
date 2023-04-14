class Controller
  INITIAL_NAV_STATE = {up: nil, right: nil, down: nil, left: nil}

  attr_accessor :player, :world

  def initialize(player:, world:)
    @player = player
    @world = world

    player.state.merge!(nav: INITIAL_NAV_STATE)
  end

  def control! args
    case
    when key_down(args).up then go_north args, nav: player.state.nav
    when key_down(args).right then go_east args, nav: player.state.nav
    when key_down(args).down then go_south args, nav: player.state.nav
    when key_down(args).left then go_west args,  nav: player.state.nav
    end
  end

  def go_north(args, nav:)
    player.state.nav.up = args.tick_count
    go nav: nav,
       nav_direction: nav&.up,
       x_range: (player.x + 1..player.x + tile_width),
       y_range: (player.y + 1..player.y + tile_height)
  end

  def go_east(args, nav:)
    player.state.nav.right = args.tick_count
    go nav: nav,
       nav_direction: nav&.right,
       x_range: (player.x..player.x + tile_width),
       y_range: (player.y - tile_height..player.y)
  end

  def go_south(args, nav:)
    player.state.nav.down = args.tick_count
    go nav: nav,
       nav_direction: nav&.down,
       x_range: ((player.x + 1) - tile_width..player.x),
       y_range: ((player.y) - tile_height..player.y)
  end

  def go_west(args, nav:)
    player.state.nav.left = args.tick_count
    go nav: nav,
       nav_direction: nav&.left,
       x_range: (player.x - tile_width..player.x - 1),
       y_range: (player.y + 1..player.y + tile_height)
  end

  private

  def clear_nav! nav
    nav.merge! INITIAL_NAV_STATE
  end

  def fall!
    player.fallen!
  end

  def go(nav:, nav_direction:, x_range:, y_range:)
    return unless nav_direction

    clear_nav! nav

    return unless within_threshold?(nav_direction)

    candidate = next_tile x_range: x_range, y_range: y_range
    if candidate
      move! x: candidate.x, y: candidate.y
    else
      move! x: x_range.to_a.sample, y: y_range.to_a.sample
      fall!
    end
  end

  def key_down(args)
    args.inputs.keyboard.key_down
  end

  def move!(x:, y:)
    player.x = x
    player.y = y
  end

  def next_tile(x_range:, y_range:)
    world.tiles.detect { |tile|
      x_range.include?(tile.x) && y_range.include?(tile.y)
    }
  end

  def tile_width
    @tile_width ||= world.tiles.first.w
  end

  def tile_height
    @tile_height ||= world.tiles.first.h
  end

  def within_threshold?(integer_or_array, threshold: 10)
    array = [integer_or_array] if integer_or_array.is_a?(Integer)

    return false if array&.any?(&:nil?)

    array.all? { |n| ($args.tick_count - n) <= threshold }
  end
end
