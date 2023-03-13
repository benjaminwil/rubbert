require "app/models/tile.rb"

class World
  attr_accessor :background_colour,
                :screen_width,
                :screen_height,
                :tile_size,
                :rows

  attr_accessor :tiles

  def initialize background_colour: [0, 0, 0],
                 screen_width:,
                 screen_height:,
                 tile_size: 64,
                 rows: []
    @background_colour = background_colour
    @screen_width = screen_width
    @screen_height = screen_height
    @tile_size = tile_size
    @rows = validated_rows(rows)

    @tiles = []
  end

  def render_tiles! args
    tile_coords.map { |x, y|
      tile = Tile.new cursor_x: args.inputs.mouse.x,
                      cursor_y: args.inputs.mouse.y,
                      x: x,
                      y: y
      tiles << tile
      tile.render! args
    }
  end

  def set_background_colour! args
    args.outputs.background_color = background_colour
  end

  def tile_coords
    column_height = rows.count * tile_size

    rows.flat_map.with_index { |column_size, y_position|
      row_width = column_size * tile_size

      (0...column_size).to_a.map { |x_position|
        [
          x_for(x_position, width: row_width),
          y_for(y_position, height: column_height)
        ]
      }
    }
  end

  private

  def validated_rows rows
    max_width, max_height =
      [screen_width, screen_height].map { |n| (n / tile_size).to_i }

    rows = rows[0...max_width] if rows.count > max_width
    rows.reverse
        .map { |columns| columns <= max_height ? columns : max_height }
  end

  def x_for(index, width:)
    starting_position = U.center_point(screen_width) - U.center_point(width)
    tile_size * index + starting_position
  end

  def y_for(index, height:)
    starting_position = U.center_point(screen_height) - U.center_point(height)
    tile_size * index + starting_position
  end
end

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

def test_world_tile_generation_orthodox args, assert
  world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 50,
                    rows: [2, 5, 99]

  assert.equal! world.tile_coords, [[ 0, 50], [ 50, 50],
                                    [0, 100], [50, 100]]

  world.render_tiles! args

  assert.equal! world.tiles.count, 4
  puts world.tiles
  assert.true! world.tiles.all? { |tile| tile.is_a? Tile }
end

def test_world_tile_generation_unorthodox args, assert
  new_world = World.new screen_width: 100,
                    screen_height: 100,
                    tile_size: 60,
                    rows: [2]

  assert.equal! new_world.tile_coords, [[20, 50]]
end

def test_world_tile_generation_centered args, assert
  world = World.new screen_width: 10,
                    screen_height: 10,
                    tile_size: 1,
                    rows: [1]

  assert.equal! world.tile_coords, [[5, 5]]
end
