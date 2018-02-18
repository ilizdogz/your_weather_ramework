Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "YourWeatherFramework"
s.summary = "Loads API data and provides essential classes for your_weather app"
s.requires_arc = true

s.version = "0.2.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Krzysztof Glimos" => "kglimos@gmail.com" }

s.homepage = "https://github.com/ilizdogz/your_weather_ramework"

s.source = { :git => "git@github.com:ilizdogz/your_weather_ramework.git", :tag => "#{s.version}"}

s.framework = "UIKit"
s.swift_version = '3.2'
s.dependency 'SwiftyJSON', '~> 4.0.0'
s.dependency 'Timepiece', '~> 1.3.1'

s.source_files = "WeatherFramework/**/*.{swift}"

end
