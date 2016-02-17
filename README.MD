# アプリケーション概要
+ ニコニコ動画のランキングをクロールして、データベースに格納します
+ カテゴリ毎に再生数の多い順に表示します

# インストール方法

## NokogiriのConfig設定
```
$ bundle config build.nokogiri --use-system-libraries
```

## bundle install
```
$ bundle install --path vendor/bundle --without development test
```

## DatabaseのConfig設定
+ `config/database.yml`を適宜変更する

## Create Database
```
$ bundle exec rake db:create
```

## Database Migration
```
$ bundle exec rake db:migration
```

## クローラー実行
```
$ bundle exec rake crawl_ranking:create
```
