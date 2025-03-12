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
#rm -rf package/kernel/mt76
cp -f $GITHUB_WORKSPACE/patch/x86/router2203.json router2203.json
cp -f $GITHUB_WORKSPACE/patch/x86/config_x86-64.txt configfiles/template/.config_x86-64
cp -rf $GITHUB_WORKSPACE/patch/x86 configfiles
#cp -rf $GITHUB_WORKSPACE/patch/mt76 package/kernel
# 禁止进入默认配置
sed -i "s/make defconfig/#make defconfig/g" build
# 禁止build对argon主题修改
sed -i "s/"/img/"$model_argon/"/img/rosy.png"/g" build
# 升级内核
#git clone --single-branch -b openwrt-22.03 https://git.openwrt.org/openwrt/openwrt.git newver
#rm -f include/kernel-5.10
#cp -f newver/include/kernel-5.10 include/kernel-5.10
#cp -f target/linux/generic/pending-5.10/900-driver-22032.patch newver/900-driver-22032.patch
#rm -rf config
#rm -rf images
#rm -rf include
#rm -rf scripts
#rm -rf target
#rm -rf toolchain
#rm -rf tools
#cp -rf newver/config ./
#cp -rf newver/images ./
#cp -rf newver/include ./
#cp -rf newver/scripts ./
#cp -rf newver/target ./
#cp -rf newver/toolchain ./
#cp -rf newver/tools ./
#cp -f newver/900-driver-22032.patch target/linux/generic/pending-5.10/900-driver-22032.patch

#升级 golang
#rm -rf feeds/packages/lang/golang
#git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
