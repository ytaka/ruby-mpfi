# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mpfi/version"

Gem::Specification.new do |spec|
  spec.name        = "ruby-mpfi"
  spec.version     = MPFI::VERSION
  spec.authors     = ["Takayuki YAMAGUCHI"]
  spec.email       = ["d@ytak.info"]
  spec.homepage    = ""
  spec.summary     = "Ruby bindings of MPFI"
  spec.description = "Ruby bindings of MPFI that is a C library for interval arithmetic of multiple precision."
  spec.license = "LGPL"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib", "ext", "ext/mpfi_complex", "ext/mpfi_matrix"]
  spec.extensions    = Dir.glob('ext/**/extconf.rb')

  # specify any dependencies here; for example:
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "extconf-task"
  spec.add_runtime_dependency "ruby-mpfr"
end
