require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
desc 'Default: run unit tests.'
task :default => :test
 
desc 'Test WTF.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
 
desc 'Generate documentation for WTF.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'WTF'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name          = "wtf"
    s.version       = "0.0.1"
    s.author        = "Wyatt Greene"
    s.email         = "techiferous@gmail.com"
    s.summary       = "Converts between World Time Format and standard dates and times."
    s.description   = %Q{
      The WTF gem provides a Ruby class to convert between standard
      time and World Time Format.  For more information, visit
      http://www.worldtimeformat.com
    }
    s.require_path  = "lib"
    s.files         = ["lib/wtf.rb", "LICENSE", "Rakefile", "README",
                       "CHANGELOG",
                       "test/wtf_test.rb", "test/test_helper.rb"]
    s.homepage      = "http://github.com/techiferous/wtf"
    s.requirements  << "none"
    s.has_rdoc      = true
    s.test_files    = Dir.glob("test/**/*.rb")
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
