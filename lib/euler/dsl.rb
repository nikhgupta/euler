module Euler
  module DSL

    def cache
      Euler::Helper::Cache
    end

    def scraper
      @scraper ||= Euler::Scraper.new
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
      data[:data][:name].titlecase
    end

    # url for stats related to a problem.
    # this url is scraped to obtain solved_by statistics for all
    # the problems, which are later used as an attribute of a problem.
    def problem_stats_url(page=1)
      "http://projecteuler.net/problems;page=#{page}"
    end

    # location of the file containing solution for a given problem
    def solution_file_for(id)
      File.join(configuration["solutions"], "solution_#{"%03d" % id}.rb")
    end

    # download/prefetch all available data for a given problem.
    # This method makes use of the scraper to scrape the url of the problem.
    def prefetch(id)
      scraper.fetch_problem id
    end

  end
end

