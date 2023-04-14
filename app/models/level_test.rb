require "app/models/level.rb"

class MockWorld < World
  attr_accessor :rendered

  def initialize _hash
    @rendered = false
  end

  def render! args
    @rendered = true
  end
end

class MockPlayer < Player
  attr_accessor :rendered

  def initialize _hash
    @rendered = false
  end

  def render! args
    @rendered = true
  end
end

class MockController < Controller
  attr_accessor :controlling

  def initialize _hash
    @controlling = false
  end

  def control! args
    @controlling = true
  end
end

# In this test, we're injecting fake classes to replace the real functionality
# of our level collaborator classes. All we want to test is that the
# collaborators respond to and receive their render methods; the functionality
# of those classes should be tested elsewhere.
#
def test_level_tick args, assert
  test_level = Level.generate! args,
                               oppo: {
                                 world_class: MockWorld,
                                 player_class: MockPlayer,
                                 controller_class: MockController
                               }

  assert.false! [test_level.player.rendered,
                 test_level.world.rendered,
                 test_level.controller.controlling].all?

  test_level.tick!

  assert.true! [test_level.player.rendered,
                test_level.world.rendered,
                test_level.controller.controlling].all?
end
