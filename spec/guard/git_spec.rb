# frozen_string_literal: true

require 'fileutils'

TEST_PROJECT_PATH = 'running_test_project'

def delete_if_exists(path)
  full_path = File.join(TEST_PROJECT_PATH, path)
  File.delete(full_path) if File.exist?(full_path)
end

def ensure_guard_is_running
  delete_if_exists('is_guard_running')
  delete_if_exists('guard_is_running')

  FileUtils.touch File.join(TEST_PROJECT_PATH, 'is_guard_running')
  sleep 0.2
  return if File.exist? File.join(TEST_PROJECT_PATH, 'guard_is_running')

  raise "guard is not running in #{TEST_PROJECT_PATH}"
end

RSpec.describe Guard::Git do
  before { ensure_guard_is_running }

  it 'has a version number' do
    expect(Guard::Git::VERSION).not_to be nil
  end
end
