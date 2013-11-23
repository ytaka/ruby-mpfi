require "mpfr"
require "mpfi.so"

class MPFI < Numeric
  def subdivision(num)
    each_subdivision(num).to_a
  end
end
