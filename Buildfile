require(File.join(File.dirname(__FILE__), 'config', 'boot'))

#require 'rake'
#require 'rake/testtask'
#require 'rake/rdoctask'

#require 'tasks/rails'

THIS_VERSION = "20090909-SNAPSHOT"

repositories.remote << "http://repo1.maven.org/maven2"
repositories.remote << "http://download.java.net/maven/2"
repositories.remote << "http://www.intalio.org/public/maven2"

define 'singleshot' do
  project.version = THIS_VERSION
  project.group = "com.intalio.singleshot"

  package :war
end

repositories.release_to[:username] ||= "release"
repositories.release_to[:url] ||= "sftp://www.intalio.org/var/www-org/public/maven2"
repositories.release_to[:permissions] ||= 0664

desc "Put together a singleshot war package"
task :package do
  `warble war`
  @packagename = "singleshot-#{THIS_VERSION}"
  `mv singleshot.war target/#{@packagename}.war`
end
