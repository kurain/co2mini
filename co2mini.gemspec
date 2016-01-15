# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'co2mini/version'

Gem::Specification.new do |spec|
  spec.name          = "co2mini"
  spec.version       = CO2mini::VERSION
  spec.authors       = ["Ryutaro Kurai"]
  spec.email         = ["ryu.kurai@gmail.com"]

  spec.summary       = %q{Reading value of USB CO2 sensor 'CO2mini'.}
  spec.homepage      = "https://github.com/kurain/co2mini"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "hid_api"#, :git => 'git://github.com/kurain/ruby_hid_api.git',  :branch => "feature_report"
end
