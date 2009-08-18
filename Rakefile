require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

desc "Put together a singleshot war package"
task :package do
  `warble war`
  now = DateTime::now()
  d = Date.new(now.year, now.month, now.day)
  @packagename = "singleshot-#{d.to_s.gsub("-", "")}"
  `mv singleshot.war #{@packagename}.war`
end
