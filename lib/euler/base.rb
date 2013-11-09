module Euler
  class Base

    attr_reader :input, :solved, :input_can_change, :test_cases, :solution, :checks, :time_taken

    def initialize
      @id = self.class.to_s.gsub("Euler::Solution", "").to_i
      raise StandardError, "Unable to create object of type: Euler::Base" unless @id > 0

      @input            = nil
      @solved           = false
      @input_can_change = false
      @checks           = []
      @test_cases       = []
      @solution         = nil
      @time_taken       = 0

      self.environment
    end

    def run
      raise StandardError, "Could not find solution method!" unless self.respond_to?(@solution)
      output, @time_taken = run_with_benchmark
      return output
    end

    def run_tests
      # tests are only meaningful if the input can be varied
      return unless @input_can_change
      input = @input     # save problem's input
      @test_cases.each_with_index do |test, i|
        @input = test[:input]
        @test_cases[i][:output], @test_cases[i][:time] = run_with_benchmark
        @test_cases[i][:result] = @test_cases[i][:output] == test[:expected]
      end
      @input = input    # restore input
      @test_cases
    end

    # checks are kinda like tests, but they do not have any expectations
    def run_checks
      # checks are only meaningful if the input can be varied
      return unless @input_can_change
      input = @input     # save problem's input
      @checks.each_with_index do |check, i|
        @input = check[:input]
        @checks[i][:output], @checks[i][:time] = run_with_benchmark
      end
      @input = input    # restore input
      @checks
    end

    def run_with_benchmark
      output = nil

      time = Benchmark.measure do
        output = self.send(@solution)
      end.to_s.match(/\(\s*(.*)\)/)[1]

      [output, time]
    end

    protected

    def default_input(input)
      @input = input
      @input_can_change = true
    end

    def fixed_input(input)
      @input = input
    end

    def read_input
      # TODO: implement the method
      # @input =
    end

    def try_solution(name)
      @solution = name.is_a?(Integer) ? "solution_#{name}" : name
    end

    def mark_as_solved
      @solved = true
    end

    def test_case(input, output)
      @test_cases.push({input: input, expected: output})
    end

    def check_for(input)
      @checks.push({input: input})
    end

    def benchmark(&block)
      Benchmark.bmbm do |bm|
        bm.report do
          yield
        end
      end
    end
  end
end

