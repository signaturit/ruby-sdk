# frozen_string_literal: true

require 'rake/testtask'

require 'rubocop/rake_task'

gemspec_file = 'signaturit-sdk.gemspec'

spec = Gem::Specification.load(gemspec_file)

gem_file = "#{spec.name}-#{spec.version}.gem"

desc "Release signaturit-sdk-#{spec.version}"
task release: :build do
  unless `git branch` =~ /^\* master$/
    puts 'You must be on the master branch to release!'
    exit!
  end

  sh "git commit --allow-empty -m 'Release :gem: #{spec.version}'"
  sh "git tag #{spec.version}"
  sh 'git push origin master'
  sh "git push origin #{spec.version}"
  sh "gem push pkg/signaturit-sdk-#{spec.version}.gem"
end

desc "Build signaturit-sdk-#{spec.version} into pkg/"
task :build do
  mkdir_p 'pkg'
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

RuboCop::RakeTask.new do |t|
  t.options = %w[--format=json --out=coverage/rubocop-result.json]
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
end

task coverage: %i[test rubocop]
