class PlayerController
  INITIAL_NAV_STATE = {up: nil, right: nil, down: nil, left: nil}

  attr_accessor :player, :world

  def initialize(player:, world:)
    @player = player
    @world = world

    player.state.merge!(nav: INITIAL_NAV_STATE)
  end

  def control! args
    case
    when key_down(args).up then    player.state.nav.up = args.tick_count
    when key_down(args).right then player.state.nav.right = args.tick_count
    when key_down(args).down then  player.state.nav.down = args.tick_count
    when key_down(args).left then  player.state.nav.left = args.tick_count
    end

    go_north tick_count: args.tick_count, nav: player.state.nav
    go_east  tick_count: args.tick_count, nav: player.state.nav
    go_south tick_count: args.tick_count, nav: player.state.nav
    go_west  tick_count: args.tick_count, nav: player.state.nav
  end

  def go_north(nav:, tick_count:)
    go nav: nav,
       nav_direction: nav&.up,
       tick_count: tick_count,
       x_range: (player.x + 1..player.x + tile_width),
       y_range: (player.y + 1..player.y + tile_height)
  end

  def go_east(nav:, tick_count:)
    go nav: nav,
       nav_direction: nav&.right,
       tick_count: tick_count,
       x_range: (player.x..player.x + tile_width),
       y_range: (player.y - tile_height..player.y)
  end

  def go_south(nav:, tick_count:)
    go nav: nav,
       nav_direction: nav&.down,
       tick_count: tick_count,
       x_range: ((player.x + 1) - tile_width..player.x),
       y_range: ((player.y) - tile_height..player.y)
  end

  def go_west(nav:, tick_count:)
    go nav: nav,
       nav_direction: nav&.left,
       tick_count: tick_count,
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

  def go(nav:, nav_direction:, tick_count:, x_range:, y_range:)
    return unless nav_direction
    return unless within_threshold?(nav_direction, tick_count: tick_count)

    clear_nav! nav

    candidate = next_tile x_range: x_range, y_range: y_range

    if candidate
      move! x: candidate.x, y: candidate.y
    else
      move! x: x_range.to_a.max, y: y_range.to_a.max
      fall!
    end
  end

  def key_down(args)
    @key_down ||= args.inputs.keyboard.key_down
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

  def within_threshold?(integer_or_array, tick_count:, threshold: 300.0)
    integer_or_array = [integer_or_array] if integer_or_array.is_a?(Integer)

    return false if integer_or_array.nil? || integer_or_array.any?(&:nil?)

    integer_or_array.all? { |n| (tick_count - n) < threshold.to_i }
  end
end
