require "mpfi"
require "mpfr/matrix"
require "mpfi/matrix.so"
# If we do not load "mpfr/matrix" before load of "mpfi/matrix.so", segmentation fault error raises.

class MPFI < Numeric
  class Matrix
    def inspect
      tmp = str_ary_for_inspect2
      tmp.map!{ |a| "['" + a.join("', '") + "']"}
      sprintf("#<%s:%x, [%s]>", self.class, __id__, tmp.join(', '))
    end
    
    def pretty_print(pp)
      ary = str_ary_for_inspect2
      pp.object_group(self) do
        pp.text(sprintf(':%x, ', __id__))
        pp.breakable
        pp.text("[")
        pp.nest(1) do
          for j in 0...row_size
            pp.breakable if j > 0
            pp.text(%|["#{ary[j][0]}"|)
            pp.nest(1) do
              for i in 1...column_size
                pp.comma_breakable
                pp.text(%|"#{ary[j][i]}"|)
              end
            end
            pp.text("]")          
          end
          pp.text("]")
        end
      end
    end
    
    def to_s(delimiter = ' ')
      str_ary_for_inspect.join(delimiter)
    end

    def each_subdivision(nums)
      if block_given?
        row_size = self.row_size
        col_size = self.column_size
        if (row_size != nums.size) || !(nums.all? { |col_nums| col_nums.size == col_size })
          raise ArgumentError, "Invalid numbers to specify split"
        end
        dim = row_size * col_size
        num_current = 0
        elements = []
        row_size.times do |r|
          col_size.times do |c|
            elements << self[r, c].subdivision(nums[r][c])
          end
        end
        indices = Array.new(dim, 0)
        args = Array.new(row_size) { Array.new(col_size) }
        while num_current >= 0
          while num_current < dim
            row_num, col_num = num_current.divmod(col_size)
            if args[row_num][col_num] = elements[num_current][indices[num_current]]
              indices[num_current] += 1
            else
              indices[num_current] = 0
              num_current -= 1
              break
            end
            num_current += 1
          end
          if num_current == dim
            yield(self.class.new(args))
            num_current -= 1
          end
        end
      else
        to_enum(:each_subdivision, nums)
      end
    end

    def each_subdivision_by_size(size, &block)
      if block_given?
        row_size = self.row_size
        col_size = self.column_size
        row_num, col_num = num.divmod(col_size)
        nums = Array.new(row_size) { Array.new(col_size) }
        row_size.times do |r|
          col_size.times do |c|
            nums[r][c] = (self[r, c].diam_abs / size).ceil
          end
        end
        each_subdivision(nums, &block)
      else
        to_enum(:each_subdivision_by_size, size)
      end
    end

    def subdivision(nums)
      each_subdivision(nums).to_a
    end

    def subdivision_by_size(size)
      each_subdivision_by_size(size).to_a
    end

    def self.create(a)
      case a
      when MPFI::Vector
        if self === a
          a.dup
        else
          self.new(a.to_a)
        end
      when MPFI::Matrix
        if a.column_size == a.row_size
          if MPFI::SquareMatrix === a
            a.dup
          else
            MPFI::SquareMatrix.new(a.to_a)
          end
        else
          a.dup
        end
      when Array
        if Array == a[0] && a.size == a[0].size
          MPFI::SquareMatrix.new(a)
        else
          self.new(a)
        end
      else
        self.new(a)
      end
    end
    
    # ary is two-dimensional Array.
    def self.suitable_matrix_from_ary(ary)
      if ary.size == 1
        RowVector.new(ary[0])
      elsif ary[0].size == 1
        ColumnVector.new(ary.inject([]){ |res, val| res << val[0] })
      elsif ary[0].size == ary.size
        SquareMatrix.new(ary)
      else
        Matrix.new(ary)
      end
    end

    def self.interval(ary)
      if Array === ary && ary.all?{ |a| Array === a }
        row = ary.size
        column = ary[0].size
        if ary.all?{ |a| a.size == column }
          ret = self.new(row, column)
          (0...row).each do |i|
            (0...column).each do |j|
              case ary[i][j]
              when Array
                ret[i, j] = MPFI.interval(*ary[i][j])
              when String
                ret[i, j] = MPFI.interval(*(ary[i][j].split))
              when MPFI
                ret[i, j] = ary[i][j]
              else
                raise ArgumentError, "Invalid class for argument"
              end
            end
          end
        else
          ret = nil
        end
      end
      ret
    end
  end

  module Vector
    def inspect
      sprintf("#<%s:%x, ['%s']>", self.class, __id__, str_ary_for_inspect.join("', '"))
    end

    def pretty_print(pp)
      ary = str_ary_for_inspect
      pp.object_group(self) do
        pp.text(sprintf(':%x, ', __id__))
        pp.breakable
        pp.text(%|["#{ary[0]}"|)
        pp.nest(1) do
          for i in 1...dim
            pp.comma_breakable
            pp.text(%|"#{ary[i]}"|)
          end
        end
        pp.text("]")
      end
    end

    def to_s(delimiter = ' ')
      str_ary_for_inspect.join(delimiter)
    end

    def each_subdivision(*nums)
      if block_given?
        dim = self.size
        unless dim == nums.size
          raise ArgumentError, "Invalid numbers to specify split"
        end
        num_current = 0
        elements = nums.each_with_index.map { |num, i| self[i].subdivision(num) }
        indices = Array.new(dim, 0)
        args = []
        while num_current >= 0
          while num_current < dim
            if args[num_current] = elements[num_current][indices[num_current]]
              indices[num_current] += 1
            else
              indices[num_current] = 0
              num_current -= 1
              break
            end
            num_current += 1
          end
          if num_current == dim
            yield(self.class.new(args))
            num_current -= 1
          end
        end
      else
        to_enum(:each_subdivision, *nums)
      end
    end

    def each_subdivision_by_size(size, &block)
      if block_given?
        nums = self.size.times.map { |i| (self[i].diam_abs / size).ceil }
        each_subdivision(*nums, &block)
      else
        to_enum(:each_subdivision_by_size, size)
      end
    end

    def subdivision(*nums)
      each_subdivision(*nums).to_a
    end

    def subdivision_by_size(size)
      each_subdivision_by_size(size).to_a
    end

    def self.inner_product(a, b)
      a.inner_product(b)
    end

    def self.distance(a, b)
      a.distance_from(b)
    end
  end

  class ColumnVector
    def self.interval(ary)
      if Array === ary && ary.all?{ |a| Array === a }
        self.new(ary.map { |a| MPFI.interval(*a) })
      else
        nil
      end
    end
  end

  class RowVector
    def self.interval(ary)
      if Array === ary && ary.all?{ |a| Array === a }
        self.new(ary.map { |a| MPFI.interval(*a) })
      else
        nil
      end
    end
  end
end
