class RankingController < ApplicationController

    def history
      # cateのdefault値は"all"
      params[:cate] ||= "all"
      # 再生数の多い100件を取得
      @video = Video.order(view: 'desc').limit(100)
      # cateが"all"以外であれば、categoryで絞り込み
      @video.where!(category: params[:cate]) unless params[:cate] == "all"
    end

end
