#
# Be sure to run `pod lib lint BNGJq.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BNGJq"
  s.version          = "0.1.0"
  s.summary          = "A short description of BNGJq."
  s.description      = <<-DESC
                       An optional longer description of BNGJq

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/bongole/BNGJq"
  s.license          = 'MIT'
  s.author           = { "bongole" => "bongole2@gmail.com" }
  s.source           = { :git => "https://github.com/bongole/BNGJq.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bongole'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.public_header_files = 'Pod/Classes/**/*.h', 'Submodules/jq/{jq,jv}.h'
  s.vendored_libraries = 'Submodules/jq/build/ios/*.a'

  s.prepare_command = <<-CMD
     git submodule update --init --recursive
     cd Submodules/jq/ && ./compile-ios.sh
  CMD

end
