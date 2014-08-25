# Nickbot Module
module Nickbot
  # Command descriptions
  module COMMANDS
    HELP   = 'List available commands'
    PLACE  = "Set robot's position. Syntax: X,Y,F
        F can be one of: NORTH, SOUTH, EAST or WEST"
    MOVE   = 'Move forward in current direction'
    LEFT   = 'Rotate 90 degrees left'
    RIGHT  = 'Rotate 90 degrees right'
    REPORT = 'Announce current position and orientation'
    EXIT   = 'Shut down Nickbot'
  end

  # Status Constants
  module STATUS
    READY = 'READY'
    COMMAND_SUCCESSFUL = 'COMMAND SUCCESSFUL'
    NO_TABLE = 'NO TABLE'
    NOT_PLACED = 'NOT PLACED'
    INVALID_PLACEMENT = 'INVALID PLACEMENT'
    MOVEMENT_IMPOSSIBLE = 'MOVEMENT IMPOSSIBLE'
    UNRECOGNISED_COMMAND = 'UNRECOGNISED COMMAND'
    INVALID_COMMAND_FORMAT = 'INVALID COMMAND FORMAT'
    SHUTTINGDOWN = 'SHUTTINGDOWN'
  end

  # Placement orientations
  module ORIENTATIONS
    NORTH = :NORTH
    EAST  = :EAST
    SOUTH = :SOUTH
    WEST  = :WEST
  end
end
