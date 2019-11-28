# インストール〜hello, worldまでのメモ

DockerのCentOS7のコンテナ上にMobaSiF環境を作る

## 基本操作

### イメージの作成、Docker Hubへpush

```console
$ docker build -t ken1flan/mobasif_sample .
$ docker push ken1flan/mobasif_dample:latest
```

### コンテナの作成、実行

```console
$ docker-compose up -d
```

### コンテナのセットアップ

```console
docker-compose exec mobasif /usr/local/lib/mobalog/bin/setup.sh
```

### コンテナの停止

```console
$ docker-compose stop
```

### apache 再起動

```console
$ docker-compose exec mobasif apachectl restart
```

### apache ログ監視

```console
$ docker-compose exec mobasif tail -f /usr/local/lib/mobalog/data/log/error_log
```

### mobasif ログ監視

```console
docker-compose exec mobasif tail -f /usr/local/lib/mobalog/data/log/fcgi.err.log.$(date +%Y%m%d)
```
