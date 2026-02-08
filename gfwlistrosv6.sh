#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  sudoCmd="sudo"
else
  sudoCmd=""
fi

#copied & modified from atrandys trojan scripts
#copy from Zhihong ss scripts
if [[ -f /etc/redhat-release ]]; then
  release="centos"
  systemPackage="yum"
elif cat /etc/issue | grep -Eqi "debian"; then
  release="debian"
  systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
  release="ubuntu"
  systemPackage="apt-get"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
  systemPackage="yum"
elif cat /proc/version | grep -Eqi "debian"; then
  release="debian"
  systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "ubuntu"; then
  release="ubuntu"
  systemPackage="apt-get"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
  release="centos"
  systemPackage="yum"
fi

if [ ${systemPackage} == "yum" ]; then
    ${sudoCmd} ${systemPackage} install wget -y -q
else
    ${sudoCmd} ${systemPackage} install wget -y -qq
fi

if [ ${release} == "centos" ]; then
    nginx_root="/usr/share/nginx/html"
else
    nginx_root="/var/www/html"
fi

#download gfwlist.txt,rename base64.txt
wget -O base64.txt https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt > /dev/null 2>&1

#wait for 3s
sleep 1

gfwdns='8.8.8.8'
ttl="30m"
comment="Gfwlist"

while [ ${#} -gt 0 ]; do
    case "${1}" in
        --gfwdns | -f)
            gfwdns="$2"
            shift
            ;;
        --ttl | -t)
            ttl="$2"
            shift
            ;;
	--comment | -c)
	    comment="$2"
	    shift
	    ;;
        *)
            _red "Invalid argument: $1"
            usage 1
            ;;
    esac
    shift 1
done

gfwlist_domain_filename="./Result/gfwlist_domain.rsc"
gfwlist_source_domain_filename="./Result/gfwlist_domain_source.rsc"


chmod +x gfwlistdnsmasq.sh && sh ./gfwlistdnsmasq.sh -l -o ${gfwlist_domain_filename}

cp ${gfwlist_domain_filename} ${gfwlist_source_domain_filename}

#增加额外需要加入gfwlist的域名
echo "libreswan.org" >> ${gfwlist_domain_filename}
echo "i.ytimg.com" >> ${gfwlist_domain_filename}
#echo "download.mikrotik.com" >> ${gfwlist_domain_filename}

#开始处理 gfwlist_domain_filename 内容
#方法1
sed -i 's/\./\\\\./g; s/\(.*\)/add regexp="(\\\\.|^)\1\\$" comment=$comment type=FWD ttl=$ttl forward-to=$gfwdns/g' ${gfwlist_domain_filename}

#方法2
#1、文件中域名的"."替换成"\\."
#sed -i 's/\./\\\\./g' ${gfwlist_domain_filename}

#2、每行行首增加字符串"add regexp="(\\.|^)"
#sed -i 's/^/add regexp="(\\\\.|^)&/g' ${gfwlist_domain_filename}

#3、每行行尾增加字符串"\$" type=FWD forward-to=$gfwdns"
#sed -i 's/$/&\\$" type=FWD forward-to=$gfwdns/g' ${gfwlist_domain_filename}

#4、在文件第1行前插入新行":local gfwdns 8.8.8.8"
sed -i '1 i:local gfwdns '$gfwdns ${gfwlist_domain_filename}

#5、在文件第2行前插入新行":local comment Gfwlist"
sed -i '2 i:local comment '$comment ${gfwlist_domain_filename}

#6、在文件第3行前插入新行":local ttl 30m"
sed -i '3 i:local ttl '$ttl ${gfwlist_domain_filename}

#7、在文件第4行前插入新行"/ip dns static remove [/ip dns static find comment=Gfwlist]"
sed -i '4 i/ip dns static remove [/ip dns static find comment=Gfwlist]' ${gfwlist_domain_filename}

#8、在文件第5行前插入新行"/ip dns static"
sed -i '5 i/ip dns static' ${gfwlist_domain_filename}

# 在文件的最后一行插入新行"/ip dns cache flush"
sed -i '$ a/ip dns cache flush' ${gfwlist_domain_filename}

# 在文件的最后一行的前一行插入新行“:delay 3s;”
sed -i '$ i:delay 3s;' ${gfwlist_domain_filename}

#9、删除文件尾的换行（可选）
#tail -n 1 ${gfwlist_domain_filename} | tr -d '\n' >> gfwlist_lastline_tmp
#sed -i '$d' ${gfwlist_domain_filename}
#sed -i '$r gfwlist_lastline_tmp' ${gfwlist_domain_filename}
#rm -f gfwlist_lastline_tmp
