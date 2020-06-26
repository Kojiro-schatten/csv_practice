require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'csv'
require "pry"

urls = %w(
  https://qiita.com/search?q=ruby,
  https://qiita.com/search?q=php,
  https://qiita.com/search?q=swift
)

titles = []

charset = nil
urls.each do |url|
  html = open(url) do |f|
    charset = f.charset
    f.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)
  doc.xpath('//h1[@class="searchResult_itemTitle"]').each do |node|
    title = node.css('a').inner_text
    titles.push(title)
  end
end

CSV.open("qiita_title.csv", "w") do |csv|
  csv << titles
end

# makuake
# url = 'https://www.makuake.com/discover/projects/search'

# page = Nokogiri::HTML.parse(open(url))
# binding.pry
# makuake_text = page.xpath('div/h4').text
# p makuake_text.text
# makuake


# def setup_doc(url)
#   charset = 'utf-8'
#   html = open(url) { |f| f.read }
  # doc = Nokogiri::HTML.parse(html, nil, charset)
#   doc.search('br').each { |n| n.replace("\n") }
#   doc
# end

# def scrape(url)
#   doc = setup_doc(url)
#   page_title = doc.xpath('div/h1').text
#   detail_url = doc.xpath('div/h2/a').attribute('href').value

#   [page_title, detail_url, url]
# end

# if __FILE__ == $0
#   urls = [
#     'https://www.example1.com',
#     'https://www.example2.com',
#     'https://www.example3.com'
#   ]
#   csv_header = ['ページタイトル', '詳細URL', 'URL']

#   CSV.open('result.csv', 'w') do |csv|
#     csv << csv_header
#     urls.each do |url|
#       begin
#         csv << scrape(url)
#       rescue
#         # エラー処理
#         # 例）　csv << ['err', 'err', url]
#       end
#     end
#   end
# end