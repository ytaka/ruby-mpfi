require "mpfr"
require "mpfi.so"

class MPFI < Numeric
  def subdivision(num)
    each_subdivision(num).to_a
  end

  def each_subdivision_by_size(size, &block)
    if block_given?
      num = (self.diam_abs / size).ceil
      each_subdivision(num, &block)
    else
      to_enum(:each_subdivision_by_size, size)
    end
  end

  def subdivision_by_size(size)
    each_subdivision_by_size(size).to_a
  end
end
