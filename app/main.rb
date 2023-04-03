require "app/models/level.rb"
require "app/utilities.rb"

def enable_reset_hotkey! args
  return unless args.inputs.keyboard.key_down.r

  @level = nil

  $gtk.reset
end

def level_one args
  @level ||= Level.generate! args
end

def tick args
  enable_reset_hotkey! args

  level_one(args).tick!
end
