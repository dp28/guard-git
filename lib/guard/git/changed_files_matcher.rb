# frozen_string_literal: true

module Guard
  module Git
    # Only matches files that both:
    #
    # * Match the passed-in pattern AND
    # * Are either ignored by git or identified as changed
    class ChangedFilesMatcher
      def initialize(pattern)
        @pattern = pattern
      end

      def match(filename_or_pathname)
        path = filename_or_pathname.to_s
        result = @pattern.match(path)
        return nil if result.nil? || skip_file?(path)

        result
      end

      private

      def skip_file?(path)
        !changed?(path) && !always_allowed?(path)
      end

      def changed?(path)
        changed_files.include?(path)
      end

      def always_allowed?(path)
        ignored_files.include?(path)
      end

      def ignored_files
        `git ls-files --others -i --exclude-standard`.lines.map(&:chomp)
      end

      def changed_files
        `git status --porcelain`.lines.map do |line|
          line.chomp.split(' ').last
        end
      end
    end
  end
end
