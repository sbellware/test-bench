module TestBench
  class Run
    Error = Class.new(RuntimeError)

    def session
      @session ||= Session::Substitute.build
    end
    attr_writer :session

    def exclude_file_pattern
      @exclude_file_pattern ||= Defaults.exclude_file_pattern
    end
    attr_writer :exclude_file_pattern

    attr_reader :paths

    def initialize(*paths)
      @paths = Array(paths)
    end

    def call(&block)
      session.start

      if block.nil?
        paths.each do |path|
          path(path)
        end
      else
        block.(self)
      end

    ensure
      session.finish
    end

    def path(path)
      if File.directory?(path)
        directory(path)
      elsif File.exist?(path)
        file(path)
      else
        raise Error, "Path not found (Path: #{path.inspect})"
      end
    end
    alias_method :<<, :path

    def directory(path)
      glob_pattern = File.join(path, '**/*.rb')

      Dir[glob_pattern].sort.each do |path|
        next if exclude_file_pattern.match?(path)

        file(path)
      end
    end

    def file(path)
      session.load(path)
    end

    module Defaults
      def self.exclude_file_pattern
        pattern = ENV.fetch('TEST_BENCH_EXCLUDE_FILE_PATTERN') do
          '_init.rb$'
        end

        Regexp.new(pattern)
      end
    end
  end
end
