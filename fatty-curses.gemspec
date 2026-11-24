Gem::Specification.new { |s|
  s.name = "fatty-curses"
  s.version = "1.7.0.1"
  s.author = ["Shugo Maeda", "Eric Hodel", "Daniel E. Doherty"]
  s.email = ["ded@ddoherty.net"]
  s.homepage = "https://github.com/ddoherty03/fatty-curses"
  s.platform = Gem::Platform::RUBY
  s.summary = "Curses bindings with portable screen suspension for Fatty"
  s.description = "A fork of ruby/curses adding Curses.endwin for temporary terminal suspension without discarding the Ruby screen. Supports ncurses and bundled PDCursesMod."
  s.files = (`git ls-files --recurse-submodules -z`.split("\x0") + Dir["lib/**/*.rb"]).uniq
  unless s.files.include?("vendor/PDCursesMod/curses.h")
    raise "Initialize vendor/PDCursesMod before building: git submodule update --init --recursive"
  end
  s.extensions = ["ext/curses/extconf.rb"]
  s.require_path = "lib"
  s.required_ruby_version = Gem::Requirement.new('>= 3.0')
  s.licenses = ['Ruby', 'BSD-2-Clause']

  s.metadata["allowed_push_host"] = "https://rubygems.org"
  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"] = "#{s.homepage}/releases"
  s.metadata["documentation_uri"] = "https://ruby.github.io/curses/"

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
}
