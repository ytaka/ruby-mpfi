require 'mkmf'

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
  ruby_mpfr_dir = nil
  begin
    require "rubygems"
    spec = Gem::Specification.find_by_name("ruby-mpfr")
    ruby_mpfr_dir = File.join(spec.full_gem_path, 'ext')
  rescue LoadError
  end
  unless find_header("ruby_mpfr.h", File.join(ruby_mpfr_dir, 'mpfr'))
    header_not_found("ruby_mpfr.h")
  end
  unless find_header("ruby_mpfr_matrix.h", File.join(ruby_mpfr_dir, 'mpfr_matrix/mpfr'))
    header_not_found("ruby_mpfr_matrix.h")
  end
  find_header("ruby_mpfi.h", File.join(File.dirname(__FILE__), "../../mpfi"))
  create_makefile("mpfi/matrix")
end
