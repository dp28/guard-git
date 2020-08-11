# frozen_string_literal: true

require 'fileutils'

TEST_PROJECT_PATH = 'running_test_project'
INPUT_DIR_PATH = File.join(TEST_PROJECT_PATH, 'input')
OUTPUT_DIR_PATH = File.join(TEST_PROJECT_PATH, 'output')

def delete_if_exists(path)
  File.delete(path) if File.exist?(path)
end

def input_file_path(name)
  File.join(INPUT_DIR_PATH, name)
end

def output_file_path(name)
  File.join(OUTPUT_DIR_PATH, name)
end

def ensure_guard_is_running
  input_file = input_file_path('is_guard_running')
  delete_if_exists(input_file)

  return if guard_creates_file?('guard_is_running') { FileUtils.touch(input_file) }

  raise "guard is not running in #{TEST_PROJECT_PATH}"
end

def in_test_project(&block)
  Dir.chdir(TEST_PROJECT_PATH, &block)
end

def change_branch(branch_name)
  in_test_project { `git checkout #{branch_name}` }
end

def did_guard_create_file?(file_path, timeout_in_seconds, sleep_increment_in_seconds: 0.05)
  slept_so_far = 0
  while slept_so_far < timeout_in_seconds
    return true if File.exist?(file_path)

    sleep sleep_increment_in_seconds
    slept_so_far += sleep_increment_in_seconds
  end

  false
end

def guard_creates_file?(file_name, timeout_in_seconds: 2)
  file_path = output_file_path(file_name)
  delete_if_exists(file_path)

  yield

  did_guard_create_file?(file_path, timeout_in_seconds)
end

def guard_triggered?(timeout_in_seconds: 2, &block)
  guard_creates_file?('guard_ran', timeout_in_seconds: timeout_in_seconds, &block)
end

RSpec.describe Guard::Git do
  before(:all) { ensure_guard_is_running }

  it 'has a version number' do
    expect(Guard::Git::VERSION).not_to be nil
  end

  describe 'when files change because the branch is changed' do
    before do
      change_branch('master')
      ensure_guard_is_running
    end

    it 'does not trigger guard' do
      triggered = guard_triggered? { change_branch('other_branch') }
      expect(triggered).to be false
    end
  end
end
