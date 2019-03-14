$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sheets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sheets"
  s.version     = Sheets::VERSION
  s.authors     = ["Runar Ingebrigtsen"]
  s.email       = ["runar@voit.no"]
  s.homepage    = "http://voit.no"
  s.summary     = "Add spreadsheet functionality to your Rails app."
  s.description = "Data models and assets for use in spreadsheet-like web apps."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.11"
  s.add_dependency "rubyzip", ">= 1.2.1"
  s.add_dependency "rubyXL", "~> 3.3"
  s.add_dependency "best_in_place", "~> 3.0"

  s.add_development_dependency "sqlite3"
end
