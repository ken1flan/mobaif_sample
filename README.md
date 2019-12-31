# MobaSiF Sample

これは[MobaSiF](https://ja.osdn.net/projects/moba/)をDocker上で動くことを確認するために作った、記事管理ツールです。

## Quick Start

### 前提条件

DockerとDocker Composeが使えること。

### 手順

## 開発

### コンテナの構成

mobasifとmariadbの2つで構成しています。

#### mobasif

#### mariadb

### テストの実行

#### 全体

テストすべてを実行するには下記のコマンドを実行してください。

```console
$ cd /usr/local/lib/mobalog
$ bin/prove -r test
```

#### 単体

ひとつのテストを実行するには下記のコマンドを実行してください。
`bin/prove`の代わりに`bin/perl`でも実行できます。

```console
$ cd /usr/local/lib/mobalog
$ bin/prove test/pm/Session.t
```
