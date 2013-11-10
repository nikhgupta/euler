module Euler
  class CLI < Thor
    include Euler::DSL

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

