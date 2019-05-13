# インストール〜hello, worldまでのメモ

DockerのCentOS7のコンテナ上にMobaSiF環境を作る

## Docker基本操作

### イメージの作成

```bash
$ docker build -t moba .
```

### コンテナの作成、実行

`mobalog`という名前をつけて、カレントディレクトリをマウントしています。

```bash
$ docker run --name moba -v $(pwd):/usr/local/lib/mobalog -p 8080:80 -itd moba
```

### コンテナで作業

```bash
$ docker exec -it moba bash
```

### コンテナから出る

```bash
$ exit
```

### コンテナの一時停止

```bash
$ docker pause moba
```

### コンテナの一時停止からの再開

```bash
$ docker unpause moba
```

### コンテナの再開

```bash
$ docker start moba
```

### コンテナの一蘭

```bash
$ docker ps -a
```

### コンテナの破棄

```bash
$ docker rm moba
```

### イメージの一覧

```bash
$ docker images
```

### イメージの破棄

```bash
$ docker rmi moba
```

### イメージの履歴

```bash
$ docker history moba
```

### イメージの変更を戻す

```bash
$ docker tag 1607065afa42 moba:latest
```

### apache 起動

```bash
$ docker exec -it moba /usr/sbin/httpd -D FOREGROUND
```

### apache ログ監視

```bash
$ docker exec moba tail -f /var/log/mobalog/error_log
```