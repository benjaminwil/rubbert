require "app/models/world.rb"
require "app/models/player.rb"
require "app/models/player_controller.rb"

class Level
  class << self
    def generate! args,
                  world_params: {
                    screen_width: args.grid.right,
                    screen_height: args.grid.top,
                    rows: [1, 2, 3, 4, 5, 6, 7, 8]
                  }
      world = World.new world_params

      # FIXME:
      # It would be nice if the player wasn't dependent on the state of the
      # world.
      #
      player = Player.new x: world.tiles.first.x,
                          y: world.tiles.first.y,
                          w: world.tile_size,
                          h: world.tile_size,
                          state: args.state.player_one

      new args: args, world: world, player: player
    end
  end

  def execute!
    world.render! args
    player.render! args
    controller.control! args
  end

  private

  attr_accessor :args, :controller, :player, :world

  def initialize(args:, world:, player:)
    @args = args
    @world = world
    @player = player

    @controller = PlayerController.new player: player, world: world
  end
end
