require "app/utilities.rb"

require "app/models/world.rb"

def tick args
  world = World.new screen_width: args.grid.right,
                    screen_height: args.grid.top,
                    rows: [1,2,5,4,5,6,7,8]
  world.set_background_colour! args
  world.render_tiles! args
end
