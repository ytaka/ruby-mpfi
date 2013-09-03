# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mpfi/version"

Gem::Specification.new do |s|
  s.name        = "ruby-mpfi"
  s.version     = MPFI::VERSION
  s.authors     = ["Takayuki YAMAGUCHI"]
  s.email       = ["d@ytak.info"]
  s.homepage    = ""
  s.summary     = "Ruby bindings of MPFI"
  s.description = "Ruby bindings of MPFI that is a C library for interval arithmetic of multiple precision."

  s.rubyforge_project = "ruby-mpfi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "ext", "ext/mpfi_complex", "ext/mpfi_matrix"]
  s.extensions    = Dir.glob('ext/**/extconf.rb')

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"
  s.add_development_dependency "extconf-task"
  s.add_runtime_dependency "ruby-mpfr"
end
