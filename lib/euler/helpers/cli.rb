module Euler
  module Helper
    module CLI
      # This method, simply, imitates the 'say' method that the Thor gem provides us.
      # I preferred to use this method, since it gives us a very nice UI at the CLI :)
      def say(status, message = "", log_status = true)
        @shell ||= Thor::Shell::Color.new
        log_status = false if @options and @options[:quiet]
        @shell.say_status(status, message, log_status)
      end

      # Show some information to the user in Cyan.
      def show_info(message)
        say "Information", message, :cyan
      end

      # Show a success message to the user in Green.
      def say_success(message)
        say "Success", message, :green
      end

      # Show a failed message to the user in Yellow.
      def say_failed(message)
        say "Failed!!", message, :yellow
      end

    end
  end
end
