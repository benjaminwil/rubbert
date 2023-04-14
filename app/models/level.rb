require "app/models/world.rb"
require "app/models/player.rb"
require "app/models/controller.rb"

class Level
  class << self
    def generate! args,
                  oppo: {
                    world_class: World,
                    player_class: Player,
                    controller_class: Controller
                  },
                  world_params: {
                    screen_width: args.grid.right,
                    screen_height: args.grid.top,
                    rows: [1, 2, 3, 4, 5, 6, 7, 8]
                  }

      world = oppo.world_class.new world_params

      # FIXME:
      # It would be nice if the player wasn't dependent on the state of the
      # world.
      #
      player = oppo.player_class.new x: world.tiles.first.x,
                                     y: world.tiles.first.y,
                                     w: world.tile_size,
                                     h: world.tile_size,
                                     state: args.state.player_one

      controller = oppo.controller_class.new player: player,
                                             world: world

      new args: args, world: world, player: player, controller: controller
    end
  end

  def tick!
    world.render! args
    player.render! args
    controller.control! args
  end

  private

  attr_accessor :args, :controller, :player, :world

  def initialize(args:, world:, player:, controller:)
    @args = args
    @world = world
    @player = player
    @controller = controller
  end
end
