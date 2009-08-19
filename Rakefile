require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

THIS_VERSION = "2009.08.18.2"

repositories.release_to[:username] ||= "release"
repositories.release_to[:url] ||= "sftp://www.intalio.org/var/www-org/public/maven2"
repositories.release_to[:permissions] ||= 0664

desc "Put together a singleshot war package"
task :package do
  `warble war`
  @packagename = "singleshot-#{THIS_VERSION}"
  `mv singleshot.war #{@packagename}.war`
end
