Pod::Spec.new do |spec|

  spec.name         = "ContextMenuSwift"
  spec.version      = "0.0.6"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = <<-DESC
This CocoaPods library helps you with context menu for older ios versions.
                   DESC

  spec.homepage     = "https://github.com/umerjabbar/ContextMenuSwift"
  spec.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  spec.author       = { "Umer Jabbar" => "umerabduljabbar@icloud.com" }

  spec.ios.deployment_target = "10.0"
  spec.swift_version = "5"

  spec.source        = { :git => "https://github.com/umerjabbar/ContextMenuSwift.git", :tag => "#{spec.version}" }
  spec.source_files  = "ContextMenuSwift/**/*.{h,m,swift,xib}"

end
