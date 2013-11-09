module Euler
  class CLI < Thor
    include Euler::DSL

    def initialize; @debug = true; end
    def download_problems(args = [])
    end

    # prepares a single problem for solving
    # this method will create a solution file for you, which you can use to readily start
    # solving euler problems.
    def prepare_solution(id)
      unless cache.valid?("problem_#{id}")
        debug "Downloading problem from Project Euler"
        prefetch id
      end

      data = Euler::Helper::Cache.get("problem_#{id}")[:data]
      file = File.join(configuration["solutions"], "solution_#{"%03d" % id}.rb")
      FileUtils.mkdir_p configuration["solutions"] unless File.directory?(config["solutions"])

      len  = 76
      lbr  = "=" * 76
      code = <<-CODE
        #!/usr/env/bin/ruby
        # encoding: utf-8

        # The Problem: #{url_for(id)}
        # #{lbr}
        # #{data[:text].break_even(len, "# ")}
        # #{lbr}
        # Solved by: #{data[:solved_by]} users.
        # Time Spent on Problem: 0 minute.
        # #{lbr}

        require 'euler'

        module Euler
          class Solution#{id} < Base
            def environment
              # this method sets up environment for this problem.
              # you should only set options for this problem here.

              default_input 1000   # input can take arbitrary values, specify a default value.
              # fixed_input 1000   # if solution or problem does not allow arbitrary values for input.
              # read_input         # input is read from the problem statement itself

              # use test cases? can be defined multiple times.
              # test cases are only available, when input is set to be: "default"
              # test_case 10, 23    # output should be 23 when input is 10

              # try method named: "solution_<n>" for solving this problem.
              try_solution 1        # assume "solution_1" to be current

              # uncomment the following, when this problem has been solved.
              # mark_as_solved
            end

            def solution_1
              # start writing your solution here..
              # input is available in variable: "@input"
            end

            def solution_2(input)
              # a second variation of the solution to this problem
              # this solution can be run by setting: "try_solution 2" inside "run" method

              # delete this method, if not needed, though it wont harm! :)
            end

            def named_solution(input)
              # a third variation of the solution to this problem
              # this solution can be run by setting: "try_solution 'named_solution'" inside "run" method
            end

          end
        end
      CODE

      File.open(file, "w") {|f| f.puts code.delete_indents(8)} unless File.exists?(file)
      puts file
    end

    def run_solution(id)
      name = "(" + "%03d" % id + ") " + title_for(id)
      puts "\n" + name + "\n" + "=" * name.length + "\n"

      file = solution_file_for(id)
      require file

      solution = Euler.const_get("Solution#{id}").new

      passed = true
      if solution.test_cases.any?
        puts
        debug "Running tests associated with this problem."
        tests = solution.run_tests
        tests.each do |test|
          message  = "<< TEST >> Input: #{test[:input].inspect}"
          message += " | Output: #{test[:output].inspect}"
          message += " | Expected: #{test[:expected].inspect}" unless test[:result]
          message += " | Runtime: #{test[:time]}"
          message += " | Status: #{test[:result] ? "Passed" : "Failed"}!"
          debug message
          passed = false and break unless test[:result]
        end
      end

      if passed
        output = solution.run
        puts "\nOutput is: #{output} | Time Elapsed: #{solution.time_taken} seconds"
      else
        debug "All tests must pass before the solution can be run for real input!"
      end
    end

    def run_checks(id)
      name = "(" + "%03d" % id + ") " + title_for(id)
      puts "\n" + name + "\n" + "=" * name.length + "\n"

      file = solution_file_for(id)
      require file

      solution = Euler.const_get("Solution#{id}").new

      if solution.checks.any?
        puts
        debug "Running checks associated with this problem."
        checks = solution.run_checks
        checks.each do |check|
          message  = "<< CHECK >> Input: #{check[:input].inspect}"
          message += " | Output: #{check[:output].inspect}"
          message += " | Runtime: #{check[:time]}"
          debug message
        end
      end

    end

    private

    def debug(message, indent = 0)
      puts "[DEBUG] " + (" " * indent * 2) + " -- " + message
    end
  end
end

