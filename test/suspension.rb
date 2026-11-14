# Run in a terminal: ruby -Ilib -Iext/curses test/suspension.rb
require 'curses'
require 'rbconfig'

begin
  screen = Curses.init_screen
  Curses.raw
  Curses.noecho
  window = Curses::Window.new(3, 40, 1, 1)
  3.times do |n|
    window.setpos(0, 0)
    window.addstr("Before suspension #{n}")
    window.refresh
    raise 'save mode failed' unless Curses.def_prog_mode
    raise 'endwin failed' unless Curses.endwin
    raise 'not suspended' unless Curses.closed?
    raise 'screen object replaced' unless Curses.stdscr.equal?(screen)
    GC.start
    raise 'child failed' unless system(RbConfig.ruby, '-e', 'puts "CHILD-OUTPUT-OK"')
    raise 'restore mode failed' unless Curses.reset_prog_mode
    window.setpos(1, 0)
    window.addstr("After suspension #{n}")
    window.refresh
    raise 'did not resume' if Curses.closed?
  end
ensure
  window&.close
  Curses.close_screen
end
puts 'SUSPEND-RESUME-OK'
