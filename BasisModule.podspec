
Pod::Spec.new do |s|

  
  s.name         = "BasisModule"
  s.version      = "1.2.1.1"
  s.summary      = "一个简易的网络模块."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  

  s.homepage     = "https://github.com/huangzhentong/BaseModule"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  #s.license      = "MIT (example)"
   s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "huang" => "181310067@qq.com" }
  # Or just: s.author    = "huang"
  # s.authors            = { "huang" => "181310067@qq.com" }
  # s.social_media_url   = "http://twitter.com/huang"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
   s.platform     = :ios, "9.0"

 


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/huangzhentong/BaseModule.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #s.source_files  = "Networking/*.{h,m}"
  

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

s.subspec 'Networking' do |ss|
    ss.ios.deployment_target = '9.0'
    
    ss.dependency 'AFNetworking'
    ss.dependency 'BasisModule/Manager'
    ss.public_header_files = 'Networking/*.h'
    ss.source_files = 'Networking/*.{h,m}'
end

s.subspec 'BaseRouterManager' do |ss|
   	ss.ios.deployment_target = '9.0'
    	ss.dependency 'BasisModule/Networking'
   	ss.dependency 'BasisModule/Manager'
   	#ss.dependency 'MGJRouter'
	ss.dependency 'AFNetworking'
   	ss.public_header_files = 'BaseRouterManager/*.h'
        ss.source_files = 'BaseRouterManager/*.{h,m}'
end
s.subspec 'Manager' do |ss|
   	ss.ios.deployment_target = '9.0'
  
   	ss.public_header_files = 'Manager/*.h'
        ss.source_files = 'Manager/*.{h,m}'
end
#s.subspec 'Category' do |ss|
   	
#   	ss.dependency 'BasisModule/BaseRouterManager'
 
#   	ss.dependency 'ReactiveObjC', '~> 3.0.0'
	
#   	ss.public_header_files = 'Category/*.h'
#        ss.source_files = 'Category/*.{h,m}'
#end

end
