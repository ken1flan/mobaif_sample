# インストール〜hello, worldまでのメモ

DockerのCentOS7のコンテナ上にMobaSiF環境を作る

## Docker基本操作

### イメージの作成、Docker Hubへpush

```bash
$ docker build -t ken1flan/mobasif_sample .
$ docker push ken1flan/mobasif_dample:latest
```

### コンテナの作成、実行

```bash
$ docker-compose up -d
```

### コンテナの停止

```bash
$ docker-compose stop
```

### apache 起動

```bash
$ docker-compose exec mobasif apachectl restart
```

### apache ログ監視

```bash
$ docker-compose exec mobasif tail -f /usr/local/lib/mobalog/data/log/error_log
```

### mobasif ログ監視

```bash
docker-compose exec mobasif tail -f /usr/local/lib/mobalog/data/log/fcgi.err.log.$(date +%Y%m%d)
```
