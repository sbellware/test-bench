require_relative '../../automated_init'

context "Output" do
  context "Writer" do
    context "Styling Selection" do
      context "Detect" do
        styling = Controls::Output::Styling.detect

        context do
          writer = Output::Writer.build(styling: styling)

          test "Styling attribute" do
            assert(writer.styling == styling)
          end
        end

        context "Interactive Device" do
          device = Controls::Device::Interactive.example

          writer = Output::Writer.build(device, styling: styling)

          test "Enabled" do
            assert(writer.styling? == true)
          end
        end

        context "Non-Interactive Device" do
          device = Controls::Device::Interactive::Non.example

          writer = Output::Writer.build(device, styling: styling)

          test "Disabled" do
            assert(writer.styling? == false)
          end
        end
      end

      context "On" do
        styling = Controls::Output::Styling.on

        device = Controls::Device::Interactive::Non.example

        writer = Output::Writer.build(device, styling: styling)

        test "Styling attribute" do
          assert(writer.styling == styling)
        end

        test "Enabled" do
          assert(writer.styling? == true)
        end
      end

      context "Off" do
        styling = Controls::Output::Styling.off

        device = Controls::Device::Interactive.example

        writer = Output::Writer.build(device, styling: styling)

        test "Styling attribute" do
          assert(writer.styling == styling)
        end

        test "Disabled" do
          assert(writer.styling? == false)
        end
      end

      context "Invalid" do
        styling = Controls::Output::Styling::Invalid.example

        test "Raises an error" do
          assert_raises(Output::Writer::Error) do
            Output::Writer.build(styling: styling)
          end
        end
      end
    end
  end
end
