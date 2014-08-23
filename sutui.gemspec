Gem::Specification.new do |s|
  s.name        = 'sutui'
  s.version     = '0.0.1'
  s.date        = '2014-08-23'
  s.summary     = "Sutui Apis' Ruby SDK"
  s.description = "Sutui Apis' Ruby wrapper"
  s.authors     = ["Martin"]
  s.email       = 'martin@beansmile.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/beansmile/sutui'
  s.license       = 'MIT'

  s.add_runtime_dependency 'typhoeus', '~> 0.6.9'
end
