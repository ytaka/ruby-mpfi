require "rspec"

gem_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
$:.unshift(File.join(gem_root, "lib"))
Dir.glob(File.join(gem_root, "ext/*")).each do |dir|
  $:.unshift(dir)
end

require "mpfr"
require "mpfr/rspec"
require "mpfi"
require "mpfi/complex"
require "mpfi/matrix"

require File.join(gem_root, "spec/mpfi/generate_number_module")
require File.join(gem_root, "spec/mpfi_matrix/generate_matrix_arguments")
