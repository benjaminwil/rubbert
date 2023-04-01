require "app/models/player_controller.rb"

def player(x:, y:, w:, h:, state:)
  @player ||= Player.new state: state, x: x, y: y, w: h, h: h
end

def controller(player:, world:)
  @controller ||= PlayerController.new player: player, world: world
end

def world(args)
  @world ||=
    World
      .new(screen_width: 6,
           screen_height: 6,
           rows: [1,2,3], tile_size: 2)
      .tap { |world| world.set_background_colour!(args)
                     world.render_tiles!(args) }
end

def render!(args, world:, player:)
  world.tap { |w| w.set_background_colour! args
                  w.render_tiles! args }
  player.render! args
end

def test_player_position args, assert
  world_one = world args
  player = player x: world_one.tiles.first.x,
                  y: world_one.tiles.first.y,
                  w: world_one.tile_size,
                  h: world_one.tile_size,
                  state: args.state.player_one

  render! args, player: player, world: world_one
  controller(player: player, world: world_one).tap { |c|
    c.control! args
  }

  assert.equal! [player.x, player.y], [0, 0]

  args.inputs.keyboard.key_down.up = true
  5.times do
    tick args
    args.state.tick_count += 1
    args.inputs.keyboard.key_down.up = false
  end
  args.inputs.keyboard.key_up.up = true

  assert.equal! [player.x, player.y], [1, 2]
end
