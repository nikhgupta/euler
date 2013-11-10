require 'timeout'

module Euler
  class Base

    attr_reader :input, :answer, :error, :time,
                :solved, :input_can_change, :solution, :terminate_at,
                :tests, :checks


    def initialize
      @id = self.class.to_s.gsub("Euler::Solution", "").to_i
      raise StandardError, "Unable to create object of type: Euler::Base" unless @id > 0

      @input            = nil    # input that will be passed to the solution
      @answer           = nil    # answer that was output upon execution
      @error            = nil    # any error that occurred when executed
      @time             = 0      # time taken to execute
      @solved           = false  # has the solution been marked as solved?
      @input_can_change = false  # can the input vary? (true, if default_input was used)
      @solution         = nil    # method used for execution
      @terminate_at     = 60     # terminate execution if time exceeds this limit (in seconds)
      @tests            = []     # various tests  for the problem (output equals expectation?)
      @checks           = []     # various checks for the problem (input => output)

      self.environment           # override above vars with user-settings
    end

    def run
      @answer, @time, @error = run_with_benchmark
    end

    def perform_tests
      # tests & checks are only meaningful if the input can be varied
      return unless @input_can_change
      @tests.each_with_index do |test, i|
        output, time, error = run_with_benchmark(test[:input])
        @tests[i].merge!({ output: output, time: time,
                          error: error, passed: output == test[:expected]})
      end
      @tests
    end

    # checks are kinda like tests, but they do not have any expectations
    def perform_checks
      # tests & checks are only meaningful if the input can be varied
      return unless @input_can_change
      @checks.each_with_index do |check, i|
        output, time, error = run_with_benchmark(check[:input])
        @checks[i].merge!({ output: output, time: time, error: error })
      end
      @checks
    end

    protected

    def default_input(input)
      @input = input
      @input_can_change = true
    end

    def fixed_input(input)
      @input = input
    end

    # TODO: implement the method
    def read_input
    end

    def try_solution(name)
      @solution = name.is_a?(Integer) ? "solution_#{name}" : name
    end

    def mark_as_solved
      @solved = true
    end

    def test_case(input, output)
      @tests.push({input: input, expected: output})
    end

    def check_for(input)
      @checks.push({input: input})
    end

    # TODO: implement the method
    def benchmark(&block)
    end

    # terminate the solution if running it takes longer than given seconds
    def terminate_at(seconds = 60)
      @terminate_at = seconds
    end

    # compare the current solution to the following approaches
    # TODO: implement the method
    def compare_to_approach(*args)

    end

    private

    def run_with_benchmark(input = nil, solution = nil)
      _input     = @input           # copy current input
      @input     = input if input   # override input
      solution ||= @solution
      answer = error = nil

      unless self.respond_to?(solution)
        error = "Could not find method: #{solution}"
        return [answer, 0, error]
      end

      time = Benchmark.measure do
        begin
          Timeout::timeout(@terminate_at) do
            answer = self.send(solution)
          end
        rescue Timeout::Error
          answer = nil
          error  = "Killed execution after #{@terminate_at} seconds."
        end
      end.to_s.match(/\(\s*(.*)\)/)[1]

      @input = _input                # restore input
      [answer, time, error]
    end
  end
end

