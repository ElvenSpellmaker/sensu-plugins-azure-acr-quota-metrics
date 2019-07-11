lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/sensu-plugins-azure-acr-quota-metrics/version'

Gem::Specification.new do |s|
  s.authors                = ['Jack']
  s.date                   = Date.today.to_s
  s.description            = 'A hacky Sensu plug-in to provide ACR Quota metrics by calling out to `az`'
  s.executables            = Dir.glob('bin/**/*.{rb}').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*') + %w[README.md install.bash]
  s.license                = 'MIT'
  s.homepage               = 'https://github.com/ElvenSpellmaker/sensu-plugins-azure-acr-quota-metrics'
  s.metadata               = { 'maintainer'         => '@ElvenSpellmaker',
                               'development_status' => 'active',
                               'production_status'  => 'unstable - testing recommended',
                               'release_draft'      => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-plugins-azure-acr-quota-metrics'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.3'
  s.summary                = 'Sensu metrics plugin for Azure Container Registry Quota Metrics'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsAzureAcrQuotaMetrics::Version::VER_STRING

  s.add_runtime_dependency 'json',         '2.1.0'
  s.add_runtime_dependency 'parallel',     '1.12.1'
  s.add_runtime_dependency 'mixlib-cli',   '1.7.0'
  s.add_runtime_dependency 'sensu-plugin', '>= 1.2', '< 5.0'

  s.add_development_dependency 'rspec', '~> 3.0'
end
