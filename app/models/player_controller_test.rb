require "app/models/level.rb"

def test_player_position args, assert
  test_level =
    Level.generate! args,
                    world_params: {
                      screen_width: 6,
                      screen_height: 6,
                      rows: [1, 2, 3],
                      tile_size: 2
                    }
  player = test_level.player

  assert.equal! [player.x, player.y], [0, 0]

  T.before_tick args do
    test_level.execute!
    args.inputs.keyboard.key_down.up = true
  end

  T.before_tick args, count: 5 do
    test_level.execute!
    args.inputs.keyboard.key_down.up = false
  end

  T.before_tick args do
    test_level.execute!
    args.inputs.keyboard.key_up.up = true
  end

  assert.equal! [player.x, player.y], [1, 2]
end
