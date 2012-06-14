# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name        = "sql_origin"
  gem.homepage    = "http://github.com/RISCfuture/sql_origin"
  gem.license     = "MIT"
  gem.summary     = %Q{Add backtraces to your query log and queries themselves.}
  gem.description = %Q{Ever wonder where a SQL query comes from? This gem lets you add abbreviated backtraces to those queries, either in the query log, or as a comment in the query itself.}
  gem.email       = "rubygems@timothymorgan.info"
  gem.authors     = ["Tim Morgan"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'
YARD::Rake::YardocTask.new('doc') do |doc|
  doc.options << '-m' << 'markdown' << '-M' << 'redcarpet'
  doc.options << '--protected' << '--no-private'
  doc.options << '-r' << 'README.md'
  doc.options << '-o' << 'doc'
  doc.options << '--title' << 'SQL:Origin Documentation'

  doc.files = %w( lib/**/* README.md )
end                                                              
