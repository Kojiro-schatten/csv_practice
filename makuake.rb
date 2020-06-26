require 'nokogiri'
require 'open-uri'
require 'csv'
require "pry"

 #取得したいURLを配列に格納する
urls = %w(
  https://www.makuake.com/project/kaze/?from=similar-recommend-a&disp_order=2
)

#取得したい値のxpathを格納する
xpaths = [
  '/html/body/div[4]/div[2]/aside/div[2]/div[1]/div[1]/p[3]', #目標金額
 '/html/body/div[4]/div[3]/section/div[2]/div[2]/a/span', #サポーター
 '/html/body/div[4]/div[3]/section/div[1]/h2', #タイトル
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[1]/a/h5', #リターン１
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[1]/a/p[2]/span', #リターン１サポーター数
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[1]/a/div[3]/span', #残り
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[2]/a/h5', #リターン２
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[2]/a/p[2]/span', #リターン２サポーター数 
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[2]/a/div[3]/span', #残り
 '/html/body/div[4]/div[7]/div[2]/section/div[2]/section[3]/a/h5', #リターン３
]

values = []
hash = {}

#csvで出力する際のヘッダーを格納
hash[0] = %w(目標金額 サポーター タイトル リターン１ サポーター数 残り リターン２ サポーター数 残り リターン３ サポーター数 残り)

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

  CSV.open("makuake.csv", "w") do |csv|
    hash.count.times do |i|
    csv.add_row(hash[i])
  end
 end