# frozen_string_literal: true

require 'fileutils'
require 'support/files'

# For communication with a separately-running guard process.
# Necessary for verifying end-to-end behaviour in integration specs.
class GuardProcess
  class << self
    def ensure_is_running(timeout_in_seconds: 2)
      input_file = input_file_path('is_guard_running')
      Files.delete_if_exists(input_file)

      return if recreates_file?('guard_is_running', timeout_in_seconds) do
        FileUtils.touch(input_file)
      end

      raise "guard is not running in #{Files::TEST_PROJECT_PATH}"
    end

    def triggered_by?(timeout_in_seconds: 2, &block)
      recreates_file?('guard_ran', timeout_in_seconds, &block)
    end

    private

    def recreates_file?(file_name, timeout_in_seconds)
      file_path = output_file_path(file_name)
      Files.delete_if_exists(file_path)

      yield

      created_file?(file_path, timeout_in_seconds)
    end

    def created_file?(file_path, timeout_in_seconds, sleep_increment_in_seconds: 0.05)
      slept_so_far = 0
      while slept_so_far < timeout_in_seconds
        return true if File.exist?(file_path)

        sleep sleep_increment_in_seconds
        slept_so_far += sleep_increment_in_seconds
      end

      false
    end

    def input_file_path(name)
      Files.path_to('input', name)
    end

    def output_file_path(name)
      Files.path_to('output', name)
    end
  end
end
