require_relative '../../automated_init'

context "Output" do
  context "Run Summary" do
    context "Error" do
      error = Controls::Error.example

      output = Output::Summary::Run.new

      output.error_count = 11

      output.error(error)

      test "Error count is incremented" do
        assert(output.error_count == 12)
      end
    end
  end
end
