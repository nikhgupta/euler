class String
  # preserve line breaks but remove a fixed indentation from all lines
  def delete_indents(m = 8)
    self.split("\n\n").map{|x| x.gsub(/^\s{#{m}}/, '') }.join("\n\n")
  end

  def titlecase
    tr('_', ' ').
      gsub(/\s+/, ' ').
      gsub(/\b\w/){ $`[-1,1] == "'" ? $& : $&.upcase }
  end

  def break_even(len = 78, delim = "")
    parts = self.split("\n")
    parts.each_with_index do |part, i|
      binding.pry
      parts[i] = part.scan(/.{1,#{len}}[\b|\W|\n]/).map(&:strip).join("\n" + delim)
    end
    parts.join("\n" + delim)
  end

  def shorten(count = 45)
    if self.length >= count
      shortened = self[0, count]
      splitted = shortened.split(/\s/)
      words = splitted.length
      splitted[0, words-1].join(" ") + ' ...'
    else
      self + ( " " * (count + 1 - self.length))
    end
  end

  def sanitize_as_filename
    self.gsub(/[^\w\s_-]+/, '')
    .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
    .gsub(/\s+/, '_')
  end
end

class Array
  #   ["31"]                 # [31]
  #   ["31, 35"]             # [31,35]
  #   ["31", "35", "58-62"]  # [31,35,58,59,60,61,62]
  #   ["23", "31,35,58-62"]  # [23,31,35,58,59.60,61,62]
  def parse_as_list
    self.join(",").split(",").map do |i|
      i = i.strip.split("-")
      i.length > 1 ? (i[0]..i[1]).to_a : i[0]
    end.flatten
  end
end
