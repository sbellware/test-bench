require_relative '../../../../automated_init'

context "Output" do
  context "Session" do
    context "Assert Block" do
      context "Failure" do
        context "Verbose" do
          output = Output::Session.new

          output.verbose = true

          Output::PrintError.configure(output, writer: output.writer)

          caller_location_1 = Controls::CallerLocation.example
          caller_location_2 = Controls::CallerLocation::Alternate.example

          control_fixture = Controls::Fixture.example(output)

          control_fixture.instance_exec do
            test "Some test" do
              assert(caller_location: caller_location_1) do
                comment "Some text"

                assert(false, caller_location: caller_location_2)
              end
            end
          end

          test do
            control_text = <<~TEXT
            Starting test "Some test"
              Entering assert block (Caller Location: #{caller_location_1}, Depth: 1)
                Some text
                #{caller_location_2}: Assertion failed (TestBench::Fixture::AssertionFailure)
              Exited assert block (Caller Location: #{caller_location_1}, Depth: 1, Result: failure)
            Some test
              #{caller_location_1}: Assertion failed (TestBench::Fixture::AssertionFailure)
            TEXT

            assert(output.writer.written?(control_text))
          end
        end
      end
    end
  end
end
