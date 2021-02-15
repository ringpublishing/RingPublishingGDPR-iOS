Pod::Spec.new do |s|
    s.name         = "RingPublishingGDPR"
    s.version      = "1.3.0"
    s.homepage     = "https://github.com/ringpublishing/RingPublishingGDPR-iOS"
    s.summary      = "Collects and saves user's consent in accordance with the standard TCF2.0"
    s.license      = { :type => 'Copyright. Ringier Axel Springer Polska', :file => 'LICENSE' }
    s.authors      = { "Adam Szeremeta" => "adam.szeremeta@ringieraxelspringer.pl" }
    s.source       = { :git => "git@github.com:ringpublishing/RingPublishingGDPR-iOS.git", :tag => s.version }

    s.platform = :ios, '11.0'
    s.ios.deployment_target = '11.0'
    s.static_framework = true
    s.requires_arc = true
    s.swift_version = '5.1'
    s.frameworks = 'UIKit', 'WebKit'

    s.source_files = ['RingPublishingGDPR/Classes/**/*.{swift}']
    s.resource_bundles = { 'RingPublishingGDPR' => ['RingPublishingGDPR/Resources/**/*.{strings,xib,js,xcassets}'] }

end
