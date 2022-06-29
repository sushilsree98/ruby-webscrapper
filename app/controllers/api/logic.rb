require "date"
class Scrapper
    attr_accessor :date_1, :date_2
    @@unparsed_page
    @@parsed_page
    def initialize(id, date_1 = '', date_2=Date.today())
        @@unparsed_page = HTTParty.get(id)
        @@parsed_page = Nokogiri::HTML(@@unparsed_page)
        @date_1 = date_1
        @date_2 = date_2
    end
  
    def title
        return @@parsed_page.css('span.B_NuCI').text
    end

    def price
        return @@parsed_page.css('div._16Jk6d').text
    end

    def description
        return @@parsed_page.css('div._1AN87F').text
    end

    def get_date
        return Date.parse(@date_1[:created_at].to_s) < @date_2 - 7
    end
end