###
 # @FilePath: /mx-space-install/mx-space-main.sh
 # @author: Wibus
 # @Date: 2021-08-12 15:01:23
 # @LastEditors: Wibus
 # @LastEditTime: 2022-03-06 20:51:19
 # Coding With IU
 # Blog: https://iucky.cn/
 # Description: Install Tools
### 
check_sys(){
  if [[ -f /etc/redhat-release ]]; then
    release="centos"
  elif cat /etc/issue | grep -q -E -i "debian"; then
    release="debian"
  elif cat /etc/issue | grep -q -E -i "ubuntu"; then
    release="ubuntu"
  elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
  elif cat /proc/version | grep -q -E -i "debian"; then
    release="debian"
  elif cat /proc/version | grep -q -E -i "ubuntu"; then
    release="ubuntu"
  elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
    release="centos"
  else
    echo "未知系统版本，请联系作者获取最新版本"
    release="others(无法识别)"
  fi
  bit=`uname -m`
}
install_dependencies(){
  if [[ ${release} == "centos" ]]; then
    yum update
    yum install -y git wget curl unzip vim
  elif [[ ${release} == "ubuntu" ]]; then
    apt-get update
    apt-get install -y git wget curl unzip vim
  elif [[ ${release} == "debian" ]]; then
    apt-get update
    apt-get install -y git wget curl unzip vim
  fi
}
check_software(){
  dpkg --get-selections | grep -v deinstall | grep -q "git"
  if [ $? -eq 0 ]; then
    echo "git安装成功"
  else
    echo "git安装失败，请联系开发者"
    exit 1
  fi
  dpkg --get-selections | grep -v deinstall | grep -q "wget"
  if [ $? -eq 0 ]; then
    echo "wget安装成功"
  else
    echo "wget安装失败，请联系开发者"
    exit 1
  fi
  dpkg --get-selections | grep -v deinstall | grep -q "curl"
  if [ $? -eq 0 ]; then
    echo "curl安装成功"
  else
    echo "curl安装失败，请联系开发者"
    exit 1
  fi
  dpkg --get-selections | grep -v deinstall | grep -q "unzip"
  if [ $? -eq 0 ]; then
    echo "unzip安装成功"
  else
    echo "unzip安装失败，请联系开发者"
    exit 1
  fi
  dpkg --get-selections | grep -v deinstall | grep -q "vim"
  if [ $? -eq 0 ]; then
    echo "vim安装成功"
  else
    echo "vim安装失败，请联系开发者"
    exit 1
  fi
}



clear
echo "——————mx-space一键部署程序🔫——————————"
echo "Author: Wibus"
echo "————————————————————————————————————————"
echo "您需要提前安装好的软件包如下: " 
echo "redis mongodb nginx/apache"
# whoami 检测用户类型
if [ $(whoami) != "root" ]; then
    echo "请使用root用户运行此脚本"
    exit 1
fi
echo "获取内核版本..."
KERNEL_VERSION=$(uname -r)
# 截取 KERNEL_VERSION 的前4个字符
KERNEL_VERSION_SHORT=$(echo $KERNEL_VERSION | cut -c 1-4)
# 如果小于 4.18 则退出
if [[ "${KERNEL_VERSION_SHORT}" <= "4.18" ]]; then
    echo "当前内核版本为: ${KERNEL_VERSION}"
    echo "请使用内核版本 4.18更高版本"
    exit 1
fi

echo "检测系统版本..."
# 输出系统版本
check_sys
echo "检测到系统版本为: ${release}"
echo "检测到系统位数为: ${bit}"
# 如果未知系统版本，则推出
if [[ ${release} == "others(无法识别)" ]]; then
  echo "未知系统版本，请联系作者获取最新版本"
  exit 1
fi
echo "-------------回车即开始安装-------------"
read

echo "-------------必要软件安装--------------"

install_dependencies
echo "检查是否安装成功软件..."
if [[ ${release} == "centos" ]]; then
  yum list installed | grep -q "git"
  if [ $? -eq 0 ]; then
    echo "git安装成功"
  else
    echo "git安装失败，请联系开发者"
    exit 1
  fi
  yum list installed | grep -q "wget"
  if [ $? -eq 0 ]; then
    echo "wget安装成功"
  else
    echo "wget安装失败，请联系开发者"
    exit 1
  fi
  yum list installed | grep -q "curl"
  if [ $? -eq 0 ]; then
    echo "curl安装成功"
  else
    echo "curl安装失败，请联系开发者"
    exit 1
  fi
  yum list installed | grep -q "unzip"
  if [ $? -eq 0 ]; then
    echo "unzip安装成功"
  else
    echo "unzip安装失败，请联系开发者"
    exit 1
  fi
  yum list installed | grep -q "vim"
  if [ $? -eq 0 ]; then
    echo "vim安装成功"
  else
    echo "vim安装失败，请联系开发者"
    exit 1
  fi
elif [[ ${release} == "ubuntu" ]]; then
  check_software
elif [[ ${release} == "debian" ]]; then
  check_software
fi
echo "检查redis是否安装..."
which redis-cli
if [ $? -eq 0 ]; then
  echo "redis已安装"
else
  echo "redis未安装，请联系开发者"
  exit 1
fi

echo "检查mongodb是否安装..."
which mongo
if [ $? -eq 0 ]; then
  echo "mongodb已安装"
else
  echo "mongodb未安装，请联系开发者"
  exit 1
fi
echo "检查nginx是否安装..."
which nginx
if [ $? -eq 0 ]; then
  echo "nginx已安装"
else
  echo "nginx未安装，请联系开发者"
  exit 1
fi

# 检查nodejs是否安装
echo "检查nodejs是否安装..."
nodejs_version=`nodejs -v`
if [[ ${nodejs_version} == "v"* ]]; then
  echo "nodejs已安装"
else
  echo "nodejs未安装，开始安装..."
  echo "-------------依赖安装--------------"
  echo "请输入nodejs安装版本（一般: 16）"
  read NODE -t 5
  echo "nodejs "$NODE".x 安装"
  echo "5s 后开始安装"
  echo "请检查链接: https://rpm.nodesource.com/setup_$NODE.x"
  read -t 5
  curl -sL https://rpm.nodesource.com/setup_$NODE.x | sudo -E bash -
  # 安装nodejs （centos/ubuntu/debian）
  if [[ ${release} == "centos" ]]; then
    yum -y install nodejs
  elif [[ ${release} == "ubuntu" ]]; then
    apt-get install nodejs
  elif [[ ${release} == "debian" ]]; then
    apt-get install nodejs
  fi
  echo "nodejs "$NODE".x 安装成功"
  echo "-------------依赖安装完成✅--------------"
  echo "nodejs安装成功"
fi
echo "~安装其他依赖~"
  # 检查nodejs依赖是否安装
  echo "检查yarn是否安装..."
  which yarn
  if [ $? -eq 0 ]; then
    echo "yarn已安装"
  else
    npm install -g yarn
  fi
  echo "检查pnpm是否安装..."
  which pnpm
  if [ $? -eq 0 ]; then
    echo "pnpm已安装"
  else
    npm install -g pnpm
  fi
  echo "检查pm2是否安装..."
  which pm2
  if [ $? -eq 0 ]; then
    echo "pm2已安装"
  else
    npm install -g pm2
  fi



echo "-------------接下来有几个问题需要你回答-------------"

echo "请输入您网站的名称（如: 秉性之松）"
read WEB_NAME
if [ -z "$WEB_NAME" ]; then
  WEB_NAME="秉性之松"
fi
echo "请输入您的网站描述（如: 有秉性且正直的松）"
read WEB_DESC
if [ -z "$WEB_DESC" ]; then
  WEB_DESC="有秉性且正直的松"
fi

echo "请输入你的前台域名（如: https://www.baidu.com，请务必带上协议）"
read DOMAIN
# 如果是空的
if [ -z "$DOMAIN" ]; then
  DOMAIN="iucky.cn"
fi

echo "请输入你的后台域名（如: https://www.baidu.com，请务必带上协议）"
read DOMAIN_BACK
# 如果是空的
if [ -z "$DOMAIN_BACK" ]; then
  DOMAIN_BACK="api.iucky.cn"
fi

echo "请输入允许跨域的域名（你的前台域名与后台域名将会被自动添加)，多个域名用逗号隔开"
read ALLOW_ORIGINS
# 向ALLOW_ORIGINS中添加$DOMAIN
ALLOW_ORIGINS="$DOMAIN,$DOMAIN_BACK,$ALLOW_ORIGINS"
# 如果是空的
if [ -z "$ALLOW_ORIGINS" ]; then
    ALLOW_ORIGINS="localhost:2323,127.0.0.1,localhost:9528,test-space.iucky.cn,baidu.com,www.baidu.com,admin.iucky.cn,cli.iucky.cn,google.com"
fi

echo "请输入授权码（随便输入）"
read AUTH_PASSWORD
# 如果是空的
if [ -z "$AUTH_PASSWORD" ]; then
    # 随机生成
    AUTH_PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
fi

# 获取 MONGODB_USERNAME
echo "请输入mongodb用户名（optional,可以不填写）"
read MONGODB_USERNAME
# 如果是空的
if [ -z "$MONGODB_USERNAME" ]; then
    MONGODB_USERNAME="admin"
fi
# 获取 MONGODB_PASSWORD
echo "请输入mongodb密码（optional,可以不填写）"
read MONGODB_PASSWORD
# 如果是空的
if [ -z "$MONGODB_PASSWORD" ]; then
    MONGODB_PASSWORD="admin"
fi

echo "请输入您的网易云手机号（我们不会获取到您的信息）（optional,可以不填写）"
read NETEASE_PHONE
echo "请输入您的网易云密码（我们不会获取到您的信息）（optional,可以不填写）"
read NETEASE_PASSWORD
echo "请输入您的Google分析ID （optional,可以不填写）"
read GOOGLE_ANALYTICS_ID
echo "请输入您的备案号（optional,可以不填写）"
read RECORD_NUMBER
echo "请输入当点击备案号跳转的地址（optional,可以不填写）"
read RECORD_URL
echo "请输入bilibiliId （optional,可以不填写）"
read BILIBILI_ID
# 如果是空的
if [ -z "$BILIBILI_ID" ]; then
    BILIBILI_ID="0"
fi
echo "请输入捐赠通道链接（optional,可以不填写，默认为innei的捐赠通道）"
read DONATE_URL
# 如果是空的
if [ -z "$DONATE_URL" ]; then
    DONATE_URL="https://afdian.net/@Innei"
fi
echo "请输入GitHub用户名（optional,可以不填写）"
read GITHUB_USERNAME
# 如果是空的
if [ -z "$GITHUB_USERNAME" ]; then
    GITHUB_USERNAME="wibus-wee"
fi
echo "请输入QQ跳转链接（optional,可以不填写）"
read QQ_URL
echo "请输入Twitter跳转链接（optional,可以不填写）"
read TWITTER_URL


echo "请问您的服务器在国内还是国外？(国内: cn，国外: us，默认cn)"
read SERVER_TYPE
# 如果是空的
if [ -z "$SERVER_TYPE" ]; then
    SERVER_TYPE="cn"
fi
echo "是否需要另外安装中后台？（y/n，默认为否，不建议另外安装）"
read NEED_ADMIN
# 如果是空的
if [ -z "$NEED_ADMIN" ]; then
    NEED_ADMIN="n"
fi
if [ "$NEED_ADMIN" = "y" ]; then
    echo "请输入你的中后台域名（如: www.baidu.com）"
    read DOMAIN_ADMIN
    # 如果是空的
    if [ -z "$DOMAIN_BACK" ]; then
        echo "请输入你的中后台域名（如: www.baidu.com）"
        read DOMAIN_ADMIN
    fi
    # 输入中后台站点文件夹路径
    echo "请输入你的中后台站点文件夹路径（如: /www/wwwroot/admin.test.cn/）"
    read ADMIN_PATH
    # 如果是空的
    if [ -z "$ADMIN_PATH" ]; then
        echo "请输入你的中后台站点文件夹路径（如: /www/wwwroot/admin.test.cn/）"
        read ADMIN_PATH
    fi
fi

# echo "是否需要每次启动服务器时自动启动mx-space？（y/n，默认为否）"
# read NEED_START_MX_SPACE
# # 如果是空的
# if [ -z "$NEED_START_MX_SPACE" ]; then
#     NEED_START_MX_SPACE="n"
# fi

echo "因为在给用户使用的时候需要自己修改src内的文件，因此会有可能会在git pull的时候出现有冲突的情况"
echo "是否需要为你制作默认的kami更新脚本？（y/n，默认为否）"
echo "请注意! 此脚本仅会为你备份以下文件: .env configs.ts manifest.json ecosystem.config.js"
read NEED_KAMI_UPDATE
# 如果是空的
if [ -z "$NEED_KAMI_UPDATE" ]; then
    NEED_KAMI_UPDATE="n"
fi

echo "-------------好的👌脚本将会按照上面几个问题的答案为你安装Mix-Space-------------"

echo "-------------开始安装Mix-Space-------------"

echo "-------------设置变量中-------------"

if [ "$SERVER_TYPE" = "cn" ]; then
  echo "根据地域设置GIT_BASE_URL中..."
  GIT_BASE_URL='https://github.com.cnpmjs.org/'
else
  echo "根据地域设置GIT_BASE_URL中..."
  GIT_BASE_URL='https://github.com/'
fi

echo "获取本机IP中..."
IP=$(curl -s -4 icanhazip.com)

echo "获取redis-cli的位置"
REDIS_CLI_PATH=$(which redis-cli)

echo "获取GitHub图标跳转链接"
GITHUB_URL="https://github.com/$GITHUB_USERNAME"

echo "输出全部变量"
echo "WEB_NAME: $WEB_NAME"
echo "WEB_DESC: $WEB_DESC"
echo "DOMAIN: $DOMAIN"
echo "DOMAIN_BACK: $DOMAIN_BACK"
echo "ALL_DOMAIN: $ALL_DOMAIN"
echo "GIT_BASE_URL: $GIT_BASE_URL"
echo "IP: $IP"
echo "REDIS_CLI_PATH: $REDIS_CLI_PATH"
echo "AUTH_PASSWORD: $AUTH_PASSWORD"
echo "MONGODB_USERNAME: $MONGODB_USERNAME"
echo "MONGODB_PASSWORD: $MONGODB_PASSWORD"
echo "NETEASE_PHONE: $NETEASE_PHONE"
echo "NETEASE_PASSWORD: $NETEASE_PASSWORD"
echo "GOOGLE_ANALYTICS_ID: $GOOGLE_ANALYTICS_ID"
echo "RECORD_NUMBER: $RECORD_NUMBER"
echo "RECORD_URL: $RECORD_URL"
echo "BILIBILI_ID: $BILIBILI_ID"
echo "DONATE_URL: $DONATE_URL"
echo "GITHUB_USERNAME: $GITHUB_USERNAME"
echo "QQ_URL: $QQ_URL"
echo "TWITTER_URL: $TWITTER_URL"
echo "GITHUB_URL_USER: $GITHUB_URL_USER"
echo "SERVER_TYPE: $SERVER_TYPE"
echo "NEED_ADMIN: $NEED_ADMIN"
echo "DOMAIN_ADMIN: $DOMAIN_ADMIN"
echo "ADMIN_PATH: $ADMIN_PATH"
# echo "NEED_START_MX_SPACE: $NEED_START_MX_SPACE"
echo "NEED_KAMI_UPDATE: $NEED_KAMI_UPDATE"


echo "------------安装前检测服务器-------------"

echo "获取机器的内存与CPU核数中..."
MEMORY=$(free -m | awk "/Mem:/{print $2}")
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
# 输出
echo "内存: $MEMORY MB"
echo "CPU核数: $CPU_NUM"

echo "------------检测结束，已获得基本信息-------------"

echo "回车开始安装"
read

echo "------------开始安装Server端-------------"

cd ~
mkdir -p mx
mkdir -p ~/.mx-space/log/
cd mx

# 如果内存小于2GB，就输出错误
if [ $MEMORY -lt 2000 ]; then
  echo "服务器可使用内存不足，为您自动调整为云端编译"
  echo "!由于云端编译相关脚本暂时未能确定，因此目前只能通过screen或手写pm2配置文件来保持一直运行!"
  echo "!由于云端编译相关脚本暂时未能确定，因此目前只能通过screen或手写pm2配置文件来保持一直运行!"
  echo "!由于云端编译相关脚本暂时未能确定，因此目前只能通过screen或手写pm2配置文件来保持一直运行!"
  echo "!由于云端编译相关脚本暂时未能确定，因此目前只能通过screen或手写pm2配置文件来保持一直运行!"
  sleep 5
  npm i -g zx pm2
  npm init -y
  npm i zx
  wget -O server-deploy.js https://cdn.jsdelivr.net/gh/mx-space/server-next@master/scripts/deploy.js
  node server-deploy.js --jwtSecret=$AUTH_PASSWORD --allowed_origins=$ALLOW_ORIGINS
  pm2 reload ecosystem.config.js -- --jwtSecret=$AUTH_PASSWORD --allowed_origins=$ALLOW_ORIGINS
else
  echo "服务器可使用内存足够，为您自动调整为本地编译"
  git clone ${GIT_BASE_URL}mx-space/server-next.git --depth 1 server
  cd server && git fetch --tags && git checkout $(git rev-list --tags --max-count=1)
  pnpm i
  pnpm build
  echo "
  module.exports = {
    apps: [
      {
        name: 'mx-server',
        script: 'dist/src/main.js',
        args: '--jwtSecret=$AUTH_PASSWORD --allowed_origins=$ALLOW_ORIGINS',
        autorestart: true,
        exec_mode: 'cluster',
        watch: false,
        instances: 2,
        max_memory_restart: '230M',
        env: {
          NODE_ENV: 'production',
        },
      },
    ],
  }
  " > ecosystem.config.js
fi
echo "请前往server端的网站配置文件，在 access_log 字段上面，添加如下配置，程序将会静止3秒"
echo '
location /socket.io {
    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_pass http://127.0.0.1:2333/socket.io;
}
'
sleep 3
echo "------------Server端安装完成-------------"

echo "------------安装Kami-------------"
cd ~
cd mx
git clone ${GIT_BASE_URL}mx-space/kami.git --depth 1
cd kami
git fetch --tags && git checkout $(git rev-list --tags --max-count=1) # 最后一个稳定分支
pnpm i
rm -rf .env
touch .env
echo "
NEXT_PUBLIC_APIURL=$DOMAIN_BACK/api/v2
NEXT_PUBLIC_GATEWAY_URL=$DOMAIN_BACK
NEXT_PUBLIC_TRACKING_ID=$GOOGLE_ANALYTICS_ID
NEXT_PUBLIC_ALWAYS_HTTPS=1
NEXT_PUBLIC_SNIPPET_NAME=kami
ASSETPREFIX=
NETEASE_PHONE=$NETEASE_PHONE
NETEASE_PASSWORD=$NETEASE_PASSWORD
" > .env
cd ~/mx/kami
sed -i 'configs.ts.bak' "s/https:\/\/github.com\/Innei/$GITHUB_URL_USER/g" configs.ts # 替换配置文件中的github地址
sed -i 'configs.ts.bak' "s/https:\/\/jq.qq.com\/?_wv=1027&k=5t9N0mw/$QQ_URL/g" configs.ts
sed -i 'configs.ts.bak' "s/https:\/\/twitter.com\/__oQuery/$TWITTER_URL/g" configs.ts
sed -i 'configs.ts.bak' "s/26578164/$BILIBILI_ID/g" configs.ts
sed -i 'configs.ts.bak' "s/https:\/\/innei.ren/$DOMAIN/g" configs.ts
sed -i 'configs.ts.bak' "s/浙ICP备 20028356 号/$RECORD_NUMBER/g" configs.ts
sed -i 'configs.ts.bak' "s/http:\/\/beian.miit.gov.cn/$RECORD_URL/g" configs.ts
sed -i 'configs.ts.bak' "s/https:\/\/afdian.net\/@Innei/$DONATE_URL/g" configs.ts
cd ~/mx/kami/pages
sed -i '_document.tsx.bak' "s/静かな森/$WEB_NAME/g" _document.tsx
cd ..
cd public
sed -i 'manifest.json.bak' "s/静かな森/$WEB_NAME/g" manifest.json
sed -i 'manifest.json.bak' "s/致虚极，守静笃。/$WEB_DESC/g" manifest.json
pnpm run build
echo "------------安装Kami完成-------------"

# 如果 NEED_BACK 为 y
if [ "$NEED_BACK" = "y" ]; then
  echo "------------安装中后台-------------"
  cd ~
  cd mx
  git clone ${GIT_BASE_URL}mx-space/admin-next.git --depth 1 admin
  cd admin
  git fetch --tags && git checkout $(git rev-list --tags --max-count=1) # 最后一个稳定分支
  pnpm install
  echo "
  VITE_APP_BASE_API=$DOMAIN_BACK/api/v2
  VITE_APP_WEB_URL=$DOMAIN
  VITE_APP_GATEWAY=$DOMAIN_BACK
  VITE_APP_LOGIN_BG=https://gitee.com/xun7788/my-imagination/raw/master/images/88426823_p0.jpg
  # VITE_APP_PUBLIC_URL=https://cdn.jsdelivr.net/gh/mx-space/admin-next@gh-pages/
  "
  yarn build
  cp -rf ~/mx/admin/dist/* /www/wwwroot/$(DOMAIN_ADMIN)/ # 将静态文件复制到静态文件目录
  echo "------------中后台安装完成-------------"
fi

if [ "$NEED_KAMI_UPDATE" = "y" ]; then
  echo "------------制作Kami更新脚本中-------------"
  echo "从远程抓取kami-update.sh中"
  curl ${GIT_BASE_URL}/wibus-wee/mx-space-install-sh/main/mx-space-kami-update.sh -o kami-update.sh
  chmod +x kami-update.sh
  echo "建立更新备份文件夹"
  mkdir -p ~/mx/kami_userback && cd ~/mx/kami_userback
  echo "复制.env"
  cp ~/mx/kami/.env .env && echo "FINISH & SUCCESS"
  echo "复制config.ts"
  cp ~/mx/kami/config.ts config.ts && echo "FINISH & SUCCESS"
  echo "复制manifest.json"
  cp ~/mx/kami/public/manifest.json manifest.json && echo "FINISH & SUCCESS"
  echo "复制_document.tsx"
  cp ~/mx/kami/src/pages/_document.tsx _document.tsx && echo "FINISH & SUCCESS"
  echo "尝试运行"
  cd ..
  sh kami-update.sh
fi

echo "------------启动全部必要程序-------------"
# 检测mongodb是否启动
echo "检测mongodb是否启动中..."
while true
do
  mongo --eval "db.getSiblingDB('admin').auth('$MONGODB_USERNAME', '$MONGODB_PASSWORD')" &>/dev/null
  if [ $? -eq 0 ]; then
    echo "mongodb启动成功"
    break
  else
    echo "mongodb启动失败，等待5秒后重试"
    sleep 5
  fi
done
# 检测redis是否启动
echo "检测redis是否运行中..."
while true
do
  # $REDIS_CLI_PATH -h 127.0.0.1 -p 6379 ping &>/dev/null
  lsof -i:6379 -P -n | grep LISTEN &>/dev/null
  if [ $? -eq 0 ]; then
    echo "redis启动成功"
    break
  else
    echo "redis启动失败，等待5秒后重试"
    sleep 5
  fi
done
# 检测nginx是否启动
echo "检测nginx是否启动中..."
while true
do
  # curl -s -I 127.0.0.1 &>/dev/null
  lsof -i:80 -P -n | grep LISTEN &>/dev/null
  if [ $? -eq 0 ]; then
    echo "nginx启动成功"
    break
  else
    echo "nginx启动失败，等待5秒后重试"
    sleep 5
  fi
done

cd ~/mx/server
echo "------------启动Server-------------"
yarn prod:pm2
# 检测2333端口是否启动
echo "检测server是否已启动..."
while true
do
  # curl -s -m 5 -o /dev/null -w "%{http_code}" ${IP}:2333 &>/dev/null
  lsof -i:2333 -P -n | grep LISTEN &>/dev/null
  if [ $? -eq 0 ]; then
    echo "启动成功"
    break
  else
    echo "启动失败，等待5秒后重试"
    sleep 5
    # 如果超过5次都没有启动成功，则退出
    if [ $i -gt 5 ]; then
      echo "启动失败，请检查服务器是否正常"
      exit 1
    fi
  fi
done

cd ~/mx/kami
echo "------------启动Kami-------------"
yarn prod:pm2
# 检测2323端口是否启动
echo "检测kami是否已启动..."
while true
do
  # curl -s -m 5 -o /dev/null -w "%{http_code}" ${IP}:2323 &>/dev/null
  lsof -i:2323 -P -n | grep LISTEN &>/dev/null
  if [ $? -eq 0 ]; then
    echo "启动成功"
    break
  else
    echo "启动失败，等待5秒后重试"
    sleep 5
    # 如果超过5次都没有启动成功，则退出
    if [ $i -gt 5 ]; then
      echo "启动失败，请检查服务器是否正常"
      exit 1
    fi
  fi
done

echo "------------最后完善工作-------------"
# 创建启动脚本
touch start.sh
echo "创建启动脚本中..."
echo "
cd ~/mx/server
yarn prod:pm2
# 检测2333端口是否启动
echo 检测server是否已启动...
while true
do
  lsof -i:2333 -P -n | grep LISTEN &>/dev/null
  if [ $? -eq 0 ]; then
    echo 启动成功
    break
  else
    echo 启动失败，等待5秒后重试
    sleep 5
    # 如果超过5次都没有启动成功，则退出
    if [ $i -gt 5 ]; then
      echo 启动失败，请检查服务器是否正常
      exit 1
    fi
  fi
done
cd ~/mx/kami
yarn prod:pm2
# 检测2323端口是否启动
echo 检测kami是否已启动...
while true
do
  lsof -i:2323 -P -n | grep LISTEN &>/dev/null
  if [ $? -eq 0 ]; then
    echo 启动成功
    break
  else
    echo 启动失败，等待5秒后重试
    sleep 5
    # 如果超过5次都没有启动成功，则退出
    if [ $i -gt 5 ]; then
      echo '启动失败，请检查服务器是否正常'
      exit 1
    fi
  fi
done
" > ~/mx/start.sh

# # 如果 NEED_START_MX_SPACE 为 y
# if [ $NEED_START_MX_SPACE == "y" ]; then
# # 开机自动运行
# echo "您在开头的问题中选择了开机自启，需要提醒您的是，若在自动启动中出现问题，请手动执行 start.sh 运行"
# echo "若您已阅读完毕且已知晓，请输入y以继续"
# read -p "请输入y以继续: " NEED_START_MX_SPACE
#   if [ $NEED_START_MX_SPACE == "y" ]; then
#   echo "
#   #!/bin/bash
#   cd ~/mx/server
#   yarn prod:pm2
#   cd ~/mx/kami
#   yarn prod:pm2
#   " >> /etc/rc.d/rc.local
#   fi
# fi


echo "请前往server端的网站配置文件，在 access_log 字段上面，添加如下配置: "
echo '
location /socket.io {
    proxy_http_version 1.1;
    proxy_buffering off;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
    proxy_pass http://127.0.0.1:2333/socket.io;
}
'

echo "------------安装完成-------------"

