module Euler
  module Helper
    module Formatter

      # inclined towards converting math-like html to math-like text
      def self.html2text(html)
        scrubber = Loofah::Scrubber.new do |node|

          if self.respond_to?("__#{node.name}2text")
            text = self.send("__#{node.name}2text", node)
            node.add_next_sibling Nokogiri::XML::Text.new(text, node.document)
            node.remove
          end
        end

        # remove \r and remove any whitespace before a new line
        html = html.strip.gsub("\r\n", "\n").split("\n").map(&:strip).join("\n")
        CGI.unescapeHTML Loofah.fragment(html).scrub!(:strip).scrub!(scrubber).to_text.strip
      end

      private

      # convert powers
      def self.__sup2text(node)
        node.text == node.text.to_i.to_s || node.text.length == 1 ? "^" + node.text : node.text
      end

      # convert subscript references
      def self.__sub2text(node)
        "[" + node.text + "]"
      end

      # convert images to their alt text
      def self.__img2text(node)
        alt = node.attribute("alt").to_s.strip
        src = node.attribute("src").to_s.strip

        return " #{alt} " unless alt.empty?
        return " [Image: http://projecteuler.net/#{src}]" if src =~ /^project\/images\//

        case src.match(/images\/(.*)\.gif/)[1]
        when "blackdot" then "/"
        else "[<missing-image>]"
        end
      end

      # converts a table to nice rows and columns in plain text
      def self.__table2text(node)
        table = []; width = nil
        # text = html_to_text(node.inner_html)
        node.children.each_with_index do |tr, i|
          table.push []
          width = [0] * tr.children.length unless width
          tr.children.each_with_index do |td, j|
            text = self.html2text(td.to_s)
            width[j] = text.length if !width[j] || text.length > width[j]
            table[i].push text
          end
        end

        return "" if table.empty?
        return table[0].join(" ") if table.length == 1

        plain = ""
        table.each do |tr|
          tr.each_with_index do |td, i|
            next if td.strip.empty? || CGI.escape(td) == "%C2%A0"
            plain += "| " + td + " " * ( width[i] - td.length + 1)
          end
          plain += "|\n"
        end

        plain
      end
    end
  end
end

