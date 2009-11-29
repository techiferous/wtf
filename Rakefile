require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
desc 'Default: run unit tests.'
task :default => :test
 
desc 'Test Reggie B.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
 
desc 'Generate documentation for Reggie B.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'Reggie B.'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
