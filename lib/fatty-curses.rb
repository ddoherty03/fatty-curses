# frozen_string_literal: true

# Use this entry point to select the Fatty fork when stock curses is installed.
require_relative "curses"

unless Curses.respond_to?(:endwin)
  raise LoadError, "fatty-curses requires its patched extension; another curses extension is already loaded"
end
