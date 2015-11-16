namespace :crawl_ranking do

    desc "Rankingから動画をcrawl"
    task :create => :environment do
        category = ['g_ent2', 'ent', 'music', 'sing', 'play', 'dance', 'vocaloid', 'nicoindies', 'g_life2', 'animal', 'cooking', 'nature', 'travel', 'sport', 'lecture', 'drive', 'history', 'g_politics', 'g_tech', 'science', 'tech', 'handcraft', 'make', 'g_culture2', 'anime', 'game', 'toho', 'imas', 'radio', 'draw', 'g_other', 'are', 'diary', 'other']
        category.each do |cate|
            Anemone.crawl("http://www.nicovideo.jp/ranking/fav/hourly/"+cate, {depth_limit: 0} ) do |anemone|
                anemone.on_every_page do |page|
                    page.doc.xpath("/html/body//section[@class='content']/div[contains(@class,'contentBody')]//li[contains(@class,'videoRanking')]").each do |node|
                        title = node.xpath("./div[@class='itemContent']/p/a").text
                        date = node.xpath("./div[@class='videoList01Wrap']/p[@class='itemTime' or @class='itemTime new']/span").text
                        link = node.xpath("./div[@class='videoList01Wrap']/div[@class='itemThumbBox']/div[@class='itemThumb']/a").attribute('href').value
                        img = node.xpath("./div[@class='videoList01Wrap']/div[@class='itemThumbBox']/div[@class='itemThumb']/a/img")[1].attribute('data-original').value
                        viewCount = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'view')]/span").text.delete(',').to_i
                        comment = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'comment')]/span").text.delete(',').to_i
                        mylist = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'mylist')]/span").text.delete(',').to_i

                        video = Video.where(:url => link).first
                        if !video.nil?
                            video[:view] = viewCount
                            video[:comment] = comment
                            video[:mylist] = mylist
                            video.save
                        else
                            Video.create(:title => title, :category => cate, :url => link, :image => img, :view => viewCount, :comment => comment, :mylist => mylist, :created_at => date)
                        end
                    end
                end
            end
        end
    end
end
