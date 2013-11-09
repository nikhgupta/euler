module Euler
  class Scraper
    include Euler::DSL

    def initialize
      @agent = Mechanize.new {|a| a.user_agent_alias = "Mac Safari" }
    end

    # scrape all possible information for a problem
    def fetch_problem(id)
      data = cache.get("problem_#{id}")
      return data if data

      prob = { id: id, url: url_for(id), thread: thread_for(id) }
      page = fetch_page_for(prob[:url])

      prob[:name] = page.search("#content h2").text
      return nil if prob[:name] == "Problems" # kinda 404 test

      prob[:solved_by] = fetch_solved_by(id)[:data][:solved_by]
      prob[:raw]       = page.search("#content .problem_content").inner_html
      prob[:text]      = Euler::Helper::Formatter.html2text(prob[:raw])

      # cache the data for around 1 year, and return it
      cache.add("problem_#{id}", prob, 365)
    end

    # updates statistics for a solution vs the members who have solved it
    def fetch_solved_by(id = nil)
      data = cache.get("solved_by")
      return data_or_key(data, id) if data

      counter = 1
      data    = []
      page    = fetch_page_for(problem_stats_url(counter))
      while page.search("#content .pagination .current").first.text == counter.to_s
        rows = page.search("#content table.grid tr")
        rows.shift
        rows.each_with_index do |tr, i|
          tr = tr.search("td").map { |td| td.text }
          data.push({
            id:        tr[0].to_i,
            name:      tr[1],
            solved_by: tr[2].to_i
          })
        end
        counter += 1
        page = fetch_page_for(problem_stats_url(counter))
      end
      data = cache.add("solved_by", data, 7)
      data_or_key(data, id)
    end

    private

    def data_or_key(cached, id = nil)
      return cached unless id
      data = cached[:data].detect { |el| el[:id].to_s == id.to_s }
      { data: data, updated_on: cached[:updated_on], cached_for: cached[:cached_for]}
    end

    def fetch_page_for(url)
      @agent.get url
    end

  end
end

