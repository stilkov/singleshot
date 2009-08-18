require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

THIS_VERSION = "2009.08.18"

desc "Put together a singleshot war package"
task :package do
  `warble war`
  @packagename = "singleshot-#{THIS_VERSION}"
  `mv singleshot.war #{@packagename}.war`
end
