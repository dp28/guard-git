# frozen_string_literal: true

require 'guard/git/version'
require 'guard/git/dsl_extensions'
require 'guard/git/changed_files_matcher'

module Guard
  module Git
    def self.enable!
      ::Guard::Dsl.prepend Guard::Git::DslExtensions
    end
  end
end
