require 'nokogiri'
require 'open-uri'
require 'csv'
require "pry"

 #取得したいURLを配列に格納する
urls = %w(
  https://page.auctions.yahoo.co.jp/jp/auction/s748928904
  https://page.auctions.yahoo.co.jp/jp/auction/u358210903
  https://page.auctions.yahoo.co.jp/jp/auction/u365462144
  https://page.auctions.yahoo.co.jp/jp/auction/p769429647
  https://page.auctions.yahoo.co.jp/jp/auction/k477038354
)

#取得したい値のxpathを格納する
xpaths = [
 '//h1[@class="ProductTitle__text"]',                      #商品名
 '//dt[contains(text(),"入札件数")]/following-sibling::dd[1]/text()', #入札件数
 '//dt[contains(text(),"残り時間") and @class="Count__title"]/following-sibling::dd[1]/text()', #残り日数
 '//ul[@class="ProductImage__images"]/li[1]/div/img/@src', #画像1枚目
 '//ul[@class="ProductImage__images"]/li[2]/div/img/@src', #画像2枚目
 '//ul[@class="ProductImage__images"]/li[3]/div/img/@src', #画像3枚目
 '//ul[@class="ProductImage__images"]/li[4]/div/img/@src', #画像4枚目
 '//ul[@class="ProductImage__images"]/li[5]/div/img/@src', #画像5枚目
]

values = []
hash = {}
#csvで出力する際のヘッダーを格納
hash[0] = %w(商品名 入札件数 残り日数 画像1 画像2 画像3 画像4 画像5)

i = 1
charset = nil
urls.each do |url|
  begin
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
  rescue => e
    puts `失敗しました#{f}`
  end
  
  doc = Nokogiri::HTML.parse(html, nil, charset)
  xpaths.each do |xp|
    node = doc.xpath(xp)
    value = node.inner_text.delete("\n").delete("円")
    values.push(value)
  end
  hash[i] = values
  i += 1
  values = []
end

 CSV.open("yahuoku.csv", "w") do |csv|
   hash.count.times do |i|
   csv.add_row(hash[i])
  end
 end