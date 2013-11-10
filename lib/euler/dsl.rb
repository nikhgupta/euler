module Euler
  module DSL

    # shorthand for accessing the cache
    def cache
      Euler::Helper::Cache
    end

    # use user_config gem to read user specified configuration.
    # if such a configuration does not exist, create it.
    def configuration
      config_file = File.join(ENV['HOME'], ".euler", "conf.yml")
      uconf = UserConfig.new('.euler')
      unless File.exists?(config_file)
        defaults = { "username"  => "", "password" => "",
                     "solutions" => File.join(ENV['HOME'], "euler", "solutions") }
        UserConfig.default('conf.yaml', defaults)
        uconf.create('conf.yaml')
      end
      uconf["conf.yaml"]
    end

    # url for a given problem
    def url_for(id)
      "http://projecteuler.net/problem=#{id}"
    end

    # url for the discussion therad of a given problem
    def thread_for(id)
      "http://projecteuler.net/thread=#{id}"
    end

    # name/title for a given problem
    def title_for(id)
      data = prefetch id
      data[:name].titlecase
    end

    # location of the file containing solution for a given problem
    def solution_file_for(id)
      unless File.directory?(configuration["solutions"])
        FileUtils.mkdir_p configuration["solutions"]
      end
      File.join(configuration["solutions"], "solution_#{"%03d" % id}.rb")
    end

    # download/prefetch all available data for a given problem.
    # This method makes use of the scraper to scrape the url of the problem.
    def data_for(id)
      scraper.fetch_problem id unless cache.valid?("problem_#{id}")
      cache.get("problem_#{id}")[:data]
    end

    # this method returns results for the test cases belonging to a problem
    def results_for_tests_on(id)
      parse_solution_for(id)
      @solution.test_cases.any? ? @solution.run_tests : []
    end

    # this method returns results for the checks belonging to a problem
    def results_for_checks_on(id)
      parse_solution_for(id)
      @solution.checks.any? ? @solution.run_checks : []
    end

    # this method returns results for the answer to a problem
    def results_for(id)
      parse_solution_for(id)
      @solution.run_with_benchmark
    end

    # wrapper for downloading solved_by stats if required
    def get_solved_by_stats
      scraper.fetch_solved_by
    end

    private

    # readily available scraper agent
    def scraper
      @scraper ||= Euler::Scraper.new
    end

    # url for stats related to a problem.
    # this url is scraped to obtain solved_by statistics for all
    # the problems, which are later used as an attribute of a problem.
    def problem_stats_url(page=1)
      "http://projecteuler.net/problems;page=#{page}"
    end

    # this method returns an instance of the Solution class for the given problem
    def parse_solution_for(id)
      file = solution_file_for id
      require file unless Euler.const_defined?("Solution#{id}")
      @solution ||= Euler.const_get("Solution#{id}").new
    end
  end

end

