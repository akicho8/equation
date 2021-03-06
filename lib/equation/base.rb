module Equation
  class Base
    def self.create(**params)
      _create(params[:x_range], params[:y_range], params)
    end

    def self._create(x_range, y_range, *args)
      v = [x_range.min, y_range.min, x_range.max, y_range.max]
      unless v.all?
        raise ArgumentError, "#{name}.#{__method__}(#{x_range.inspect}, #{y_range.inspect}, *#{args.inspect}) の呼び方になっているため正しい範囲が取得できません"
      end
      new(*v, *args)
    end

    attr_accessor :x0, :y0, :x1, :y1

    def initialize(*args)
      @x0, @y0, @x1, @y1 = args
    end

    def x_range
      x0..x1
    end

    def y_range
      y0..y1
    end

    def y_by_x(*args)
      _y_by_x(*args).to_f
    end

    def x_by_y(*args)
      _x_by_y(*args).to_f
    end

    def _y_by_x(x)
      case
      when x == x0
        y0
      when x == x1
        y1
      else
        _y_by_x2(x)
      end
    end

    def _x_by_y(y)
      case
      when y == y0
        x0
      when y == y1
        x1
      else
        _x_by_y2(y)
      end
    end

    def _y_by_x2(x)
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def _x_by_y2(y)
      raise NotImplementedError, "#{__method__} is not implemented"
    end

    def self.file_output(list, options = {})
      options = {
        :filename => "_output.png",
        :key      => "right bottom",
        :terminal => "png font 'Ricty-Bold.ttf'",
        :title    => nil,
        :xlabel   => nil,
        :ylabel   => nil,
      }.merge(options)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.terminal options[:terminal]
          plot.output options[:filename].to_s
          plot.title options[:title]
          plot.xlabel options[:xlabel]
          plot.ylabel options[:ylabel]
          plot.key options[:key]
          # records.each.with_index{|e, i|
          #   plot.label "#{i.next} center at first #{e[:x]}, #{e[:y]} '#{e[:y]}'"
          # }
          list.each do |info|
            plot.data << Gnuplot::DataSet.new([info[:records].collect{|e|e[:x]}, info[:records].collect{|e|e[:y]}]) do |ds|
              ds.with = "linespoints pointtype 7 pointsize 1.25"
              if info[:name]
                ds.title = info[:name]
              else
                ds.notitle
              end
            end
          end
        end
      end
    end
  end
end
