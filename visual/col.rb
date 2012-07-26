# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent

module Visual
	class Col
		attr_reader :text
		attr_reader :color

		@text = 0
		@color = nil

		@parent = nil
		@dirty = false

		def initialize(parent = nil, text = 0, color = nil)
			@parent = parent
			@text = text
			@color = color
		end

		def text=(v)
			dirty unless @text == v
			@text = v
		end

		def color=(v)
			dirty unless @color == v
			@color = v
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
			@color.undirty unless @color.nil?
		end
	end
end
