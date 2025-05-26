lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/ovo_poeditor/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-ovo_poeditor'
  spec.version       = Fastlane::OvoPoeditor::VERSION
  spec.author        = 'Alessio Arsuffi'
  spec.email         = 'alessio.arsuffi@ovolab.com'

  spec.summary       = 'Fetch latest POEditor terms and download them as .xcstrings and .strings file'
  spec.homepage      = "https://github.com/ovolab/fastlane-plugin-ovo_poeditor"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'
end
