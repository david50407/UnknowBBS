# vim: set shiftwidth=2 tabstop=2 noexpandtab noautoindent

module Visual
	class Color
		attr_reader :bold
		attr_reader :blink
		attr_reader :forge
		attr_reader :background

		@bold = false
		@blink = false
		@forge = nil
		@back = nil

		@dirty = false
		@parent = nil

		def initialize(parent = nil, *argv)
			@parent = parent
			@bold = argv[:bold] unless argv[:bold].nil?
			@blink = argv[:blink] unless argv[:blink].nil?
			@forge = argv[:forge] unless argv[:forge].nil?
			@back = argv[:back] unless argv[:back].nil?
		end

		def bold=(v)
			dirty unless @bold == v
			@bold = v
		end

		def blink=(v)
			dirty unless @blink == v
			@blink = v
		end

		def forge=(v)
			dirty unless @forge == v
			@forge = v
		end

		def back=(v)
			dirty unless @back == v
			@back = v
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
		end
	end
end
