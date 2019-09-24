begin
  require "bundler/gem_tasks"
rescue TypeError, NameError
  # Probably using gel
end

require "rake/testtask"

Rake::TestTask.new(:test_with_split) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test
task :test => [:test_with_split, :test_without_split]

task :test_without_split do
  puts "RUNNINNG WITHOUT SPLIT"
  sh "NO_SPLIT=1 rake test_with_split"
end
