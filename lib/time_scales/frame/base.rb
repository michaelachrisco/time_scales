module TimeScales
  module Frame
    class Base
      class << self
        def parts
          @parts ||=
            _parts
            .sort_by { |part| -part.scale }
            .freeze
        end

        def outer_scope
          parts.first.scope
        end

        def precision
          parts.last.subdivision
        end

        def &(time)
          part_values = parts.map do |part|
            part & time
          end
          new(*part_values)
        end

        private

        def _parts
          []
        end
      end

      def initialize(*args)
        _initialize args
      end

      def to_time_scales_frame
        self
      end

      def type
        self.class
      end

      def parts
        @parts ||= Hash[
          self.class.parts.map do |part|
            [part.symbol, send(part.symbol)]
          end
        ]
        @parts.dup
      end

      def outer_scope
        self.class.outer_scope
      end

      def precision
        self.class.precision
      end

      # Symmetric, hash-key equality.
      def eql?(other)
        self.class == other.class &&
          _to_a == other._to_a
      end

      def ==(other)
        return true if eql?(other)
        return false unless other.respond_to?(:to_time_scales_frame)
        other = other.to_time_scales_frame
        other.outer_scope == outer_scope &&
          other.precision == precision &&
          other.begin_time_struct == begin_time_struct
      end

      def hash
        @hash ||= self.class.hash ^ _to_a.hash
      end

      def to_a
        _to_a.dup
      end

      protected

      def _to_a
        @to_a ||= self.class.parts.map do |part|
          send(part.symbol)
        end.freeze
      end

      def begin_time_struct
        @begin_time = begin
          struct = TimeStruct.new
          prepare_time_struct struct
          struct.normalize
          struct.freeze
        end
      end

      private

      def _initialize(_args_array)
        # stub
      end

      def ensure_fixnum(value)
        return value if Fixnum === value
        fail ArgumentError, 'Time part value must be of Fixnum type (a numeric integer)'
      end

      def prepare_time_struct(_struct)
        # stub
      end
    end
  end
end
