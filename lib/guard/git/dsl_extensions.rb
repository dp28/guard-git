# frozen_string_literal: true

require 'guard/git/changed_files_matcher'

module Guard
  module Git
    module DslExtensions
      def watch(pattern, &action)
        super(ChangedFilesMatcher.new(pattern), &action)
      end
    end
  end
end
