class RankingController < ApplicationController

    def history
        @products = []

        if params[:cate] == "all"
            video = Video.order(:view => 'desc').limit(100)
        else
            video = Video.where(:category => params[:cate]).order(:view => 'desc').limit(100)
        end

        video.each do |v|
            @products += [{"img" => v.image, "date" => v.created_at.strftime('%Y年%m月%d日 %H時%M分%S秒'), "comment" => v.comment.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,'), "view" => v.view.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,'), "title" => v.title, "link" => v.url}]
        end

    end

end
