require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Find all TODO's"
task :todo do
  exec "grep -Rn --exclude-dir=coverage 'TODO' *"
end

desc "Open the GetAddress console"
task :console do
  exec "./bin/console"
end
