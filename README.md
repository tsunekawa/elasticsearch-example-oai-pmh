elasticsearch-example-oai-pmh
=============================

Elasticsearch の練習用スクリプトです。
OAI-PMHを使ってリポジトリのメタデータをインデクシングして検索します。

## Require

- Elasticsearch
- Bundler (ruby gem)

## Setup

事前に config/config.yml.sample をコピーして config.yml を作成し、文中の OAI\_ACCESS\_POINT を機関リポジトリのOAI-PMHアクセスポイントURLに置き換えます。

```shell
$ elasticsearch # Elasticsearchの起動
$ bundle install
$ ./bin/setup # マッピングの設定
$ ./bin/harvest # メタデータの取得
$ ./bin/post # 記事データのインデクシング
```

## Usage

```shell
$ ./bin/search (検索キーワード)
```

## License
MIT-Licenseです。

## Author
- [常川真央](https://github.com/tsunekawa)
