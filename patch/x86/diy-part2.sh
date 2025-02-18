#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/passwall2 
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/passwall
git clone --depth=1 https://github.com/gSpotx2f/luci-app-cpu-status.git package/luci-app-cpu-status
git clone --depth=1 https://github.com/gSpotx2f/luci-app-temp-status.git package/luci-app-temp-status
# 删除已有配置
rm -rf configfiles/template/.config_x86-64
rm -rf router2203.json
cp -f $GITHUB_WORKSPACE/patch/x86/router2203.json router2203.json
cp -f $GITHUB_WORKSPACE/patch/x86/.config_x86-64 configfiles/template/.config_x86-64
cp -rf $GITHUB_WORKSPACE/patch/x86 configfiles
# 禁止进入默认配置
sed -i "s/make defconfig/#make defconfig/g" build
