module TestBench
  module CLI
    def self.call(tests_directory=nil)
      tests_directory ||= Defaults.tests_directory

      path_arguments = ParseArguments.()

      read_stdin = $stdin.tty? ? false : true

      Run.() do |paths|
        if read_stdin
          until $stdin.eof?
            path = $stdin.gets.chomp

            next if path.empty?

            paths << path
          end
        end

        if path_arguments.empty?
          unless read_stdin
            paths << tests_directory
          end
        else
          path_arguments.each do |path|
            paths << path
          end
        end
      end
    end

    module Defaults
      def self.tests_directory
        ENV.fetch('TEST_BENCH_TESTS_DIRECTORY', 'test/automated')
      end
    end
  end
end
