Pod::Spec.new do |s|
  s.name         = "MoreLoadTableView"
  s.version      = "0.0.1"
  s.summary      = "MoreLoadTableView is more load UITableView."
  s.homepage     = "https://github.com/TakayoshiMiyamoto/MoreLoadTableView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Takayoshi Miyamoto" => "takayoshi.miyamoto@gmail.com" }
  s.platform     = :ios, "7.1"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/TakayoshiMiyamoto/MoreLoadTableView.git", :tag => "0.0.1" }
  s.source_files = "Classes", "MoreLoadTableView/*.{h,m}"
end
