require 'rubygems'
require 'rake'
require 'rake/gempackagetask'

task :default => [:repackage]

spec = eval(File.read('merb-resque-mailer.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 
