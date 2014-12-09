Pod::Spec.new do |s|
  s.name         = 'XAspect'
  s.version      = '1.0.0'
  s.license      = 'MIT'
  s.summary      = 'Making code maintainable and reusable with aspect-oriented programming (AOP) for Objective-C'
  s.homepage     = 'https://github.com/xareelee/XAspect'
  s.authors      = { 'Kang-Yu Xaree Lee' => 'xareelee@gmail.com' }
  # s.source       = { :git => "https://github.com/xareelee/XAspect.git", :tag => s.version.to_s }
  
  s.requires_arc = true
  s.platform     = :ios, '6.0'
  
  s.default_subspecs = 'Core', 'Macros'

  s.public_header_files = 'XAspect/*.h'
  s.source_files = 'XAspect/*.{h,m}'

  s.library = 'c++'
  s.xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
       'CLANG_CXX_LIBRARY' => 'libc++'
  }

  s.subspec 'Core' do |ss|
    ss.source_files = 'XAspect/Core/*.{h,m,mm,c,cpp}'
  end

  s.subspec 'Macros' do |ss|
    ss.source_files = 'XAspect/Macros/*.{h,m,mm,c,cpp}'
  end
  
end
