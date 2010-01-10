# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb_resque_mailer}
  s.version = "0.1"
  s.platform = Gem::Platform::RUBY
  s.date = %q{2010-01-10}
  s.authors = ["Marcin Kulik"]
  s.email = %q{marcin.kulik@gmail.com}
  s.has_rdoc = false
  s.homepage = %q{http://sickill.net}
  s.summary = %q{Merb plugin for putting mail delivery jobs onto Resque queue}
  s.files = [ "lib/merb_resque_mailer.rb", "README.md" ]
  s.add_dependency 'resque'
end

