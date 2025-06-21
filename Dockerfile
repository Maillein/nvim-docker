FROM ubuntu:22.04

# fd-findはtelescopeのより高速なファイル検索に使うっぽい
# 最新のミドルウェアを落とせるようにadd-apt-repositoryを使えるようにする
RUN apt update && \
    apt-get update && \
    apt-get install -y software-properties-common

# 最新のミドルウェアを落とせるようにする
RUN add-apt-repository ppa:longsleep/golang-backports

# ミドルウェアのインストール
RUN apt update && \
    apt-get update && \
    apt install -y curl git ripgrep tar unzip vim wget build-essential nodejs golang-go npm php-xml fd-find libunibilium-dev openjdk-21-jdk python3 python3-venv

# （途中でlocation聞かれて -y だけでは突破できない）
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install php-cli php-mbstring -y

# neovimをインストール
RUN wget https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz && \
    tar -zxvf nvim-linux-x86_64.tar.gz && \
    mv nvim-linux-x86_64/bin/nvim usr/bin/nvim && \
    mv nvim-linux-x86_64/lib/nvim usr/lib/nvim && \
    mv nvim-linux-x86_64/share/nvim/ usr/share/nvim && \
    rm -rf nvim-linux-x86_64 && \
    rm nvim-linux-x86_64.tar.gz

# バージョン管理のnを使ってnpmの最新版を入れる（ついでにnodejsも最新版にする）
RUN npm install n -g
RUN n stable
RUN apt purge -y nodejs npm
RUN apt autoremove -y

# npmでtree-sitterをインストール
RUN npm install -g tree-sitter-cli

# 設定ファイルをコピー
COPY /config /root/.config/

WORKDIR /usr/projects

# あらかじめneovimを一度起動させ、プラグインの自動インストールを実行
RUN nvim -c 'q'
RUN chmod -R 777 /root

ENTRYPOINT ["nvim"]
