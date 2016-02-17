class RankingController < ApplicationController

    def history
      params[:cate] ||= "all"
      @video = Video.order(view: 'desc').limit(100)
      @video.where!(category: params[:cate]) unless params[:cate] == "all"
    end

end
