require 'mkmf'
require "extconf_task/mkmf_utils"

i = 0
while i < ARGV.size
  case ARGV[i]
  when '--ldflags'
    if args = ARGV[i+1]
      i += 1
      $LDFLAGS += " #{args}"
    end
  else
    raise "Invalid option: #{ARGV[i]}"
  end
  i += 1
end

dir_config('mpfr')
dir_config('mpfi')
dir_config('gmp')

if have_header('mpfr.h') && have_library('mpfr') && have_header('mpfi.h') && have_library('mpfi') && have_header('gmp.h') && have_library('gmp')
  find_header_in_gem("ruby_mpfr.h", "ruby-mpfr")
  find_header_in_gem("ruby_mpfr_matrix.h", "ruby-mpfr")
  find_header("ruby_mpfi.h", File.join(File.dirname(__FILE__), "../../mpfi"))
  create_makefile("mpfi/matrix")
end
