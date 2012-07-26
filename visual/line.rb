# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent

module Visual
	class Line
		attr_reader :cols
		attr_reader :colMax

		@cols = []
		@colMax = 0

		@dirty = false
		@parent = nil

		def initialize(parent = nil, cols = 79)
			@colMax = cols
		end

		def [](k)
			return nil if k >= @colMax
			return nil if @cols[k].nil?
			@cols[k]
		end

		def []=(k, v)
			return if k >= @colMax
			@cols[k] = v
		end

		def cols=(v)
			dirty unless @cols == v
			@cols = v
		end

		def colMax=(v)
			unless @colMax == v
				if @colMax > v and @cols.size > v
					@cols = @cols[0...v]
					@colMax = v
					dirty
				end
			end
		end

		def dirty?
			return @dirty
		end

		def dirty
			@dirty = true
			@parent.dirty unless @parent.nil?
		end

		def undirty
			@dirty = false
			for col in @cols
				col.undirty
			end
		end
	end
end
