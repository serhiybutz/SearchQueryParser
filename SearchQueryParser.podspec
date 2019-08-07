Pod::Spec.new do |spec|
  spec.name         = 'SearchQueryParser'
  spec.version      = '1.1.0'
  spec.summary      = 'A simple Google-like search-engine-query parser and marker for Swift'
  spec.homepage     = 'https://github.com/SergeBouts/SearchQueryParser'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Serge Bouts' => 'sergebouts@gmail.com' }
  spec.osx.deployment_target = '10.12'
  spec.ios.deployment_target = '12.0'
  spec.swift_version = '4.2'
  spec.source        = { :git => "#{spec.homepage}.git", :tag => "#{spec.version}" }
  spec.source_files  = 'Sources/SearchQueryParser/**/*.swift'
end
