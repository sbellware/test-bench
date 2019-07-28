module TestBench
  class CLI
    class ParseArguments
      attr_reader :argv

      def run
        @run ||= Run.build(test_run: TestBench::Run.build)
      end
      attr_writer :run

      def test_run
        run.test_run
      end

      def output
        test_run.output
      end

      def writer
        output.writer
      end

      def output_device
        @output_device ||= writer.device
      end
      attr_writer :output_device

      def initialize(argv)
        @argv = argv
      end

      def call
        option_parser.parse(argv)
      end

      def option_parser
        @option_parser ||= OptionParser.new do |parser|
          parser.banner = "Usage: #{self.class.program_name} [options] [paths]"

          parser.separator('')
          parser.separator("Informational Options")

          parser.on('-h', '--help', "Print this help message and exit successfully") do
            output_device.puts(parser.help)

            exit(true)
          end

          parser.separator(<<~TEXT)

          Paths to test files (and directories containing test files) can be given after any command line arguments or via STDIN (or both).
          If no paths are given, a default path (#{Run::Defaults.tests_directory}) is scanned for test files.

          TEXT
        end
      end

      def self.program_name
        $PROGRAM_NAME
      end
    end
  end
end
