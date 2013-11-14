lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rack-custom_logger"
  spec.version       = '0.0.2'
  spec.authors       = ["SpringMT"]
  spec.email         = ["today.is.sky.blue.sky@gmail.com"]
  spec.description   = %q{Write a gem description}
  spec.summary       = %q{Change rack default logger}
  spec.homepage      = "https://github.com/SpringMT/rack-custom_logger"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

