require "app/models/tile.rb"
require "app/utilities.rb"

class World
  attr_accessor :background_colour,
                :screen_width,
                :screen_height,
                :tile_size,
                :rows,
                :holes

  attr_accessor :tiles

  def initialize background_colour: [0, 0, 0],
                 screen_width:,
                 screen_height:,
                 tile_size: 64,
                 rows: [],
                 holes: []

    @background_colour = background_colour
    @screen_width = screen_width
    @screen_height = screen_height
    @tile_size = tile_size

    @rows = validated_rows(rows)
    @holes = validated_holes(holes)

    @tiles = [].tap { |array|
      tile_coords.each { |x, y|
        array << Tile.new(x: x, y: y, tile_size: tile_size)
      }
    }
  end

  def render! args
    set_background_colour! args
    render_tiles! args
  end

  def tile_coords
    column_height = rows.count * tile_size

    rows.flat_map.with_index { |column_size, y_position|
      row_width = column_size * tile_size

      (0...column_size).to_a.map { |x_position|
        unless hole? x_position, y_position
          [
            x_for(x_position, width: row_width),
            y_for(y_position, height: column_height)
          ]
        end
      }
    }.compact.sort_by { |x, y| [y, x] }
  end

  private

  def render_tiles! args
    tiles.each { |tile| tile.render! args }
  end

  def set_background_colour! args
    args.outputs.background_color = background_colour
  end

  def hole? col_index, row_index
    holes[row_index]&.include?(col_index) || false
  end

  def validated_holes holes
    holes = holes[0...rows.count].reverse
    holes.map { |row| row && row.map { |x_position| x_position - 1 } }
  end

  def validated_rows rows
    max_width, max_height =
      [screen_width, screen_height].map { |n| (n / tile_size).to_i }

    rows = rows[0...max_width] if rows.count > max_width
    rows = rows.reverse
               .map { |columns| columns <= max_height ? columns : max_height }

    raise "No tiles to render. Fix your world parameters." if rows.none?

    rows
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
