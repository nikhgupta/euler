require 'yaml'

module Euler
  module Helper
    module Cache

      DATA_DIR = File.join(ENV['HOME'], ".euler", "cache")

      # read the cached data, returns nil if data is old/invalid
      def self.get(name)
        data = self.read_cache(name)
        valid?(name) ? data : nil
      end

      # read the cached data even if it is old/invalid
      def self.get!(name)
        self.read_cache(name)
      end

      # invalidate if cached data is more than a week old (or given number of days)
      def self.valid?(name)
        # invalidate if cache does not exist
        return false unless File.exists?(self.cache_file_for(name))

        # invalidate if cache is old
        data = self.read_cache(name)
        data[:updated_on] > Time.now - (data[:cached_for] * 24 * 3600)
      end

      # add a timestamp and overwrite cached data
      def self.add(name, data, days = 7)
        cache = { data: data, updated_on: Time.now, cached_for: days }
        self.write_cache(name, cache)
        cache
      end

      private

      def self.cache_file_for(name)
        FileUtils.mkdir DATA_DIR unless File.directory?(DATA_DIR)
        File.join(DATA_DIR, "#{name}.yml")
      end

      def self.read_cache(name)
        file = self.cache_file_for(name)
        YAML.load_file(file) if File.exists?(file)
      end

      def self.write_cache(name, data = {})
        file = self.cache_file_for(name)
        File.open(file, "w") { |f| f.puts data.to_yaml }
      end
    end
  end
end

