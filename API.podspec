
Pod::Spec.new do |spec|

  spec.name         = "API"
  spec.version      = "0.1.1"
  spec.summary      = "Simple class for APIs"
  spec.description  = "A simple class for API calls made by Wanaldino"

  spec.homepage     = "https://cocoapods.org"

  spec.license      = "MIT"

  spec.author       = "Wanaldino"

  spec.platform     = :ios, "9.3"

  spec.swift_version = '4.0'
  
  spec.source       = { :git => "https://github.com/Wanaldino/API.git", :tag => "0.1.0" }
  spec.source_files = "API/*.swift"

end
