require "app/models/world.rb"
require "app/models/player.rb"
require "app/models/player_controller.rb"

require "app/utilities.rb"

def player(x:, y:, w:, h:, state:)
  @player ||= Player.new state: state, x: x, y: y, w: h, h: h
end

def player_controller(player:, world:)
  @controller ||= PlayerController.new player: player, world: world
end

def tick args
  world = World.new screen_width: args.grid.right,
                    screen_height: args.grid.top,
                    rows: [1,2,5,4,5,6,7,8]
  world.set_background_colour! args
  world.render_tiles! args

  player = player x: world.tiles.first.x,
                  y: world.tiles.first.y,
                  w: world.tile_size,
                  h: world.tile_size,
                  state: args.state.player_one
  player.render! args

  player_controller = player_controller(player: player, world: world)
  player_controller.control! args
end

