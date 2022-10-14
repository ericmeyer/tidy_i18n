spec = Gem::Specification.new do |s|
  s.name        = "tidy_i18n"
  s.version     = "0.1.5"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Meyer"]
  s.email       = ["emeyer@8thlight.com"]
  s.homepage    = "https://github.com/ericmeyer/tidy_i18n"
  s.summary     = %q{Helpers for I18n}
  s.description = %q{Helpers for I18n. Add ways to encourage clean locale organization.}
  s.files         = Dir.glob('lib/**/*')
  s.require_paths = ["lib"]
  s.add_runtime_dependency "i18n", "~> 1"
  s.license     = "MIT"
end
