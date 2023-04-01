require "app/models/world.rb"

def test_world_dimensions_orthodox args, assert
  world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 50,
                    rows: [2, 2]

  # Assert that the tiles per row and tiles per column have been transformed to
  # be valid.
  #
  # For a tile size of 50 on a plain of 100 x 100, that means a maximum of 2
  # rows with 2 columns each.
  #
  #     |----|----|
  #     | 50 | 50 |
  #     |----|----|
  #     | 50 | 50 |
  #     |----|----|
  #
  assert.equal! world.rows, [2, 2]
end

def test_world_dimensions_unorthodox args, assert
  new_world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 60,
                    rows: [10, 10, 10]

  # So if the world's tile size was 60, we'd end up with a maximum of 1 rows
  # with 1 column each.
  #
  #     |--------|
  #     | |----| |
  #     | | 60 | |
  #     | |----| |
  #     |--------|
  #
  assert.equal! new_world.rows, [1]
end

def test_world_tile_generation_convenient_tile_size args, assert
  world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 50,
                    rows: [2, 999, 999]

  assert.equal! world.tile_coords, [[0,  0], [50,  0],
                                    [0, 50], [50, 50]]

  world.render_tiles! args

  assert.true! world.tiles.all? { |tile| tile.is_a? Tile }
  assert.equal! world.tiles.count, 4
end

def test_world_tile_generation_inconvenient_tile_size args, assert
  world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 60,
                    rows: [2]

  assert.equal! world.tile_coords, [[20, 20]]
end

def test_world_tile_generation_with_holes args, assert
  world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 50,
                    rows: [2, 2],
                    holes: [[1], [2]]

  assert.equal! world.tile_coords, [[ 0,  0],
                                    [50, 50]]
end

def test_world_tile_generation_centered args, assert
  world = World.new screen_width: 10,
                    screen_height: 10,
                    tile_size: 1,
                    rows: [1]

  assert.equal! world.tile_coords, [[5, 5]]
end
