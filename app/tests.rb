# Reusable test utility methods.
#
class T
  class << self
    def before_tick args, count: 1, &block
      count.times do
        yield
        args.state.tick_count += 1
        tick args
      end
    end
  end
end

require "app/models/player_controller_test.rb"
require "app/models/world_test.rb"
