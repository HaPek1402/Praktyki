require "yaml"

class Configuration
	def initialize(config_file)
		@config = YAML.load_file(config_file)
	end
	def to_s
		"https://www.otomoto.pl/osobowe/#{@config['otomoto']['marka']}/od-#{@config['otomoto']['minrok']}?search%5Bfilter_float_year%3Ato%5D=#{@config['otomoto']['maxrok']}"
	end
end