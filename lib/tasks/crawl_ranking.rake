namespace :crawl_ranking do

  desc "Rankingから動画をcrawl"
  task create: :environment do
    # Configファイルの読み込み
    config = YAML.load_file("#{Rails.root}/config/config.yml")
    # カテゴリ初期化
    category = []
    # カテゴリリスト作成
    config[:nico_cate].each { |title, content| category += content.values }
    # カテゴリ毎にクロール
    category.each do |cate|
      Anemone.crawl("#{config[:nico_crawl]}#{cate}", {depth_limit: 0} ) do |anemone|
        anemone.on_every_page do |page|
          # html> body> section.content> div.contentBody > li.videoRankingに一致したノードごと
          page.doc.xpath("/html/body//section[@class='content']/div[contains(@class,'contentBody')]//li[contains(@class,'videoRanking')]").each do |node|
            # ...> div.itemContent> p> a
            title = node.xpath("./div[@class='itemContent']/p/a").text
            # ...> div.videoList01Wrap> p.itemTime or p.itemTime.new> span
            date = node.xpath("./div[@class='videoList01Wrap']/p[@class='itemTime' or @class='itemTime new']/span").text
            # ...> div.videoList01Wrap> div.itemThumbBox> div.itemThumb> a[:href]
            url = node.xpath("./div[@class='videoList01Wrap']/div[@class='itemThumbBox']/div[@class='itemThumb']/a").attribute('href').value
            # ...> div.videoList01Wrap> div.itemThumbBox> div.itemThumb> a> img.dataset('original')
            image = node.xpath("./div[@class='videoList01Wrap']/div[@class='itemThumbBox']/div[@class='itemThumb']/a/img")[1].attribute('data-original').value
            # ...> div.itemContent> div.itemData> li.view> span
            view = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'view')]/span").text.delete(',').to_i
            # ...> div.itemContent> div.itemData> li.comment> span
            comment = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'comment')]/span").text.delete(',').to_i
            # ...> div.itemContent> div.itemData> li.mylist> span
            mylist = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'mylist')]/span").text.delete(',').to_i

            # URLでDB検索
            video = Video.where(url: url).first
            # 存在する場合、再生数、コメント数、マイリスト数を更新
            unless video.nil?
              video[:view] = view
              video[:comment] = comment
              video[:mylist] = mylist
              video.save
            else
              # 新規作成
              Video.create(title: title, category: cate, url: url, image: image, view: view, comment: comment, mylist: mylist, created_at: date)
            end
          end
        end
      end
    end
  end
end
