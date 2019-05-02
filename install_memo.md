# インストール〜hello, worldまでのメモ

DockerのCentOS7のコンテナ上にMobaSiF環境を作る

## Docker基本操作

### イメージの作成

```bash
$ docker build -t moba .
```

### コンテナの作成、実行

`moba`という名前をつけて、カレントディレクトリをマウントしています。

```bash
$ docker run --name moba -v $(pwd):/usr/local/moba -p 8080:80 -itd moba
```

### コンテナで作業

```bash
$ docker attach moba
```

### コンテナから出る

```bash
$ exit
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