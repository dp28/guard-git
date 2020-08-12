# frozen_string_literal: true

require 'support/files'

class Branches
  DEFAULT = 'master'
  NON_DEFAULT = 'other_branch'

  class << self
    def change_to_default
      change(DEFAULT)
    end

    def change_to_non_default
      change(NON_DEFAULT)
    end

    def change(branch_name)
      in_test_project { `git checkout -q #{branch_name}` }
    end

    private

    def in_test_project(&block)
      Dir.chdir(Files::TEST_PROJECT_PATH, &block)
    end
  end
end
