# frozen_string_literal: true

require 'guard/git/version'

module Guard
  module Git
    def self.enable!
      ::Guard::Dsl.prepend Guard::Git::DslExtensions
    end

    module DslExtensions
      def watch(pattern, &action)
        super(pattern, &action)
      end
    end
  end
end
