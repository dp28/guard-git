# frozen_string_literal: true

ignore(%r{.*test_project/.*})

group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec' do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # lib files
    watch(%r{^lib/(.*)\.rb$}) { |m| "#{rspec.spec_dir}/#{m}_spec.rb" }
  end

  guard :rubocop, cli: ['--auto-correct'] do
    watch(/.+\.rb$/)
  end
end
