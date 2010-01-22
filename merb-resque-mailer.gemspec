# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{merb-resque-mailer}
  s.version = "0.4"
  s.platform = Gem::Platform::RUBY
  s.date = %q{2010-01-22}
  s.authors = ["Marcin Kulik"]
  s.email = %q{marcin.kulik@gmail.com}
  s.has_rdoc = false
  s.homepage = %q{http://sickill.net}
  s.summary = %q{Merb plugin for putting mail delivery jobs onto Resque queue}
  s.files = [ "lib/merb-resque-mailer.rb", "README.md", "spec/spec_helper.rb", "spec/merb-resque-mailer_spec.rb" ]
  s.add_dependency 'resque'
end
