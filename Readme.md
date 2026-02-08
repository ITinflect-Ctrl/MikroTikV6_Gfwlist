## 使用方法
- gfwlist下载地址
  wget -O base64.txt https://gitlab.com/gfwlist/gfwlist/raw/master/gfwlist.txt
  wget -O base64.txt https://pagure.io/gfwlist/raw/master/f/gfwlist.txt
  wget -O base64.txt https://repo.or.cz/gfwlist.git/blob_plain/HEAD:/gfwlist.txt
  wget -O base64.txt https://bitbucket.org/gfwlist/gfwlist/raw/HEAD/gfwlist.txt
  wget -O base64.txt https://git.tuxfamily.org/gfwlist/gfwlist.git/plain/gfwlist.txt

- 安装wget工具
  - Debian和Ubuntu命令apt-get install wget curl
  - CentOS命令yum install wget curl

- 到 [github/gfwlist](https://github.com/gfwlist/gfwlist) 项目中下载 gfwlist.txt 文件，并将该文件重命名为 base64.txt, 且放置在当前目录下
  或者在当前目录下使用 wget -O base64.txt https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt

- 执行 sh gfwlistrosv6.sh 或者 ./gfwlistrosv6.sh 为默认使用方式


- 参数说明：

  - -f [forward-to=] 默认的 forward-to=8.8.8.8, 使用 -f 参数可以指定 forward-to 的值
    ```shell
    > sh gfwlistrosv6.sh -f 8.8.8.8
    ```

  - -t [ttl=] 默认的 ttl=30m, 使用 -t 参数可以指定 ttl 的值
    ```shell
    > sh gfwlist2ros.sh -t 30m
    ```

  - -c [comment=] 默认的 comment=Gfwlist, 使用 -c 参数可以指定 comment 的值
    ```shell
    > sh gfwlistrosv6.sh -c Gfwlist
    ```

  - 组合使用
    > sh gfwlistrosv6.sh -f 8.8.8.8 -t 30m -c Gfwlist
  

- 会生成三个文件在当前目录:

  - **_gfwlist_domain_source.rsc_** - 不带规则的纯域名文件
  - **_gfwlist_domain.rsc_** - 带规则的可直接用于 ros 的规则文件
  - **_gfwlist.txt_** - base64.txt 解密后的文件


## 安装解密工具
- Debian和Ubuntu命令apt-get install base64
- CentOS命令yum install base64


## 在线解密base64文件命令
url=https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt
curl -s $url | base64 -d >> list.txt


## 有时可能还需要先安装开发工具包
sudo apt update
sudo apt-get base64
sudo apt install build-essential
sudo apt-get install manpages-dev


## 验证安装是否成功
gcc --version
g++ --version

