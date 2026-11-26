# Docker Alpine Valkey

## 版本

* [9.2 , 9.2.0 , latest](https://github.com/seffeng/docker-valkey/tree/9.2)

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/valkey

# 运行
$ docker run --name valkey-test -d -p <port>:6379 -v <data-dir>:/opt/websrv/data/valkey -v <tmp-dir>:/opt/websrv/tmp seffeng/valkey

# 例子：
$ docker run --name valkey-alias1 -d -p 6379:6379 -v /opt/websrv/data/valkey:/opt/websrv/data/valkey -v /opt/websrv/tmp:/opt/websrv/tmp seffeng/valkey

# 查看正在运行的容器
$ docker ps

# 停止
$ docker stop [CONTAINER ID | NAMES]

# 启动
$ docker start [CONTAINER ID | NAMES]

# 进入终端
$ docker exec -it [CONTAINER ID | NAMES] sh

# 删除容器
$ docker rm [CONTAINER ID | NAMES]

# 镜像列表查看
$ docker images

# 删除镜像
$ docker rmi [IMAGE ID]
```
## 备注

```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name valkey-alias1 --network network-01 --network-alias valkey-alias1 -d -p 6379:6379 -v /opt/websrv/data/valkey:/opt/websrv/data/valkey -v /opt/websrv/tmp:/opt/websrv/tmp seffeng/valkey
```
---

* [版本维护周期](https://valkey.io/topics/releases/#list-of-supported-versions)
