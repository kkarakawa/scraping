namespace :crawl_ranking do

  desc "Rankingから動画をcrawl"
  task create: :environment do
    config = YAML.load_file("#{Rails.root}/config/config.yml")
    category = []
    config[:nico_cate].each { |title, content| category += content.values }
    category.each do |cate|
      Anemone.crawl("#{config[:nico_crawl]}#{cate}", {depth_limit: 0} ) do |anemone|
        anemone.on_every_page do |page|
          page.doc.xpath("/html/body//section[@class='content']/div[contains(@class,'contentBody')]//li[contains(@class,'videoRanking')]").each do |node|
            title = node.xpath("./div[@class='itemContent']/p/a").text
            date = node.xpath("./div[@class='videoList01Wrap']/p[@class='itemTime' or @class='itemTime new']/span").text
            url = node.xpath("./div[@class='videoList01Wrap']/div[@class='itemThumbBox']/div[@class='itemThumb']/a").attribute('href').value
            image = node.xpath("./div[@class='videoList01Wrap']/div[@class='itemThumbBox']/div[@class='itemThumb']/a/img")[1].attribute('data-original').value
            view = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'view')]/span").text.delete(',').to_i
            comment = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'comment')]/span").text.delete(',').to_i
            mylist = node.xpath("./div[@class='itemContent']/div[@class='itemData']//li[contains(@class,'mylist')]/span").text.delete(',').to_i

            video = Video.where(url: url).first
            unless video.nil?
              video[:view] = view
              video[:comment] = comment
              video[:mylist] = mylist
              video.save
            else
              Video.create(title: title, category: cate, url: url, image: image, view: view, comment: comment, mylist: mylist, created_at: date)
            end
          end
        end
      end
    end
  end
end
