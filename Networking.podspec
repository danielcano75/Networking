Pod::Spec.new do |spec|
  spec.name             = "Networking"
  spec.version          = "1.0.1"
  spec.summary          = "Generic Networking framework for iOS"
  spec.homepage         = "https://github.com/danielcano75/Networking"
  spec.license          = { :type => "MIT" }
  spec.author           = { "danielcano75" => "daniel.cano.arbelaez@gmail.com" }
  spec.platform         = :ios, "16.0"
  spec.swift_versions   = "5.0"
  spec.source           = {
    :http => "https://github.com/danielcano75/Networking/releases/download/v1.0.1/Networking.xcframework.zip"
  }
  spec.vendored_frameworks = "Networking.xcframework"
end
