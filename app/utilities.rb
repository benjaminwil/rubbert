class U
  class << self
    def add_debug_label! args, debug_value, colour: [255, 255, 255]
      args.outputs.labels << [16, 36, debug_value] + colour
    end

    def center_point(number)
      (number / 2).to_i
    end
  end
end
