
Pod::Spec.new do |s|
  s.name             = 'RefreshKit'
  s.version          = '0.0.1'
  s.summary          = 'Easy Custom'

  s.description      = <<-DESC
  U can easy custom the refresh view for pull to refresh
                       DESC

  s.homepage         = 'https://github.com/AceSha/RefreshKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '81556205@qq.com' => 'shayuan@sensenets.com' }
  s.source           = { :git => 'https://github.com/AceSha/RefreshKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RefreshKit/Classes/**/*'
  s.resource = 'RefreshKit/Assets/**/*'

end
