# frozen_string_literal: true

require "test_helper"

class ReporterTest < MiniTest::Test
  def test_increment_test_count
    reporter = Ant::Reporter.new

    assert_equal 0, reporter.instance_variable_get(:@test_count)
    assert_equal 1, reporter.increment_test_count
  end

  def test_increment_assertion_count
    reporter = Ant::Reporter.new

    assert_equal 0, reporter.instance_variable_get(:@assertion_count)
    assert_equal 1, reporter.increment_assertion_count
  end

  def test_increment_success_count
    $stdout.expects(:print).with("\033[1;32m.\033[0m")
    reporter = Ant::Reporter.new

    assert_equal 0, reporter.instance_variable_get(:@success_count)
    assert_equal 1, reporter.increment_success_count
  end

  def test_increment_failure_count
    $stdout.expects(:print).with("\033[1;31mF\033[0m")
    reporter = Ant::Reporter.new
    failure_report = {
      "test/my_test.rb" => {
        "my_test" => { message: "Expected false to be truthy.", line_number: 32 }
      }
    }

    assert_equal 0, reporter.instance_variable_get(:@failure_count)
    assert_equal 1, reporter.increment_failure_count("test/my_test.rb", "my_test", 32, "Expected false to be truthy.")
    assert_equal failure_report, reporter.instance_variable_get(:@failure_report)
  end

  def test_addition_operator
    reporter = Ant::Reporter.new
    second_reporter = Ant::Reporter.new

    reporter.increment_success_count
    second_reporter.increment_assertion_count
    reporter += second_reporter

    assert_equal 1, reporter.assertion_count
    assert_equal 1, reporter.success_count
  end
end
