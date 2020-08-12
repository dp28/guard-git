# frozen_string_literal: true

class Files
  TEST_PROJECT_PATH = 'running_test_project'

  class << self
    def delete_if_exists(path)
      File.delete(path) if File.exist?(path)
    end

    def path_to(*path_parts)
      File.join(TEST_PROJECT_PATH, *path_parts)
    end
  end
end
