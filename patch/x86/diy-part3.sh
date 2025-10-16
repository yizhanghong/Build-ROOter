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
rm -rf router2305.json
#rm -rf package/kernel/mt76
cp -f $GITHUB_WORKSPACE/patch/x86/router2305.json router2305.json
cp -f $GITHUB_WORKSPACE/patch/x86/config_x86-64-2305.txt configfiles/template/.config_x86-64
cp -rf $GITHUB_WORKSPACE/patch/x86 configfiles

# 添加config
echo "
CONFIG_PACKAGE_luci-app-statistics=y
CONFIG_PACKAGE_luci-app-temp-status=y
CONFIG_PACKAGE_luci-app-cpu-status=y 
CONFIG_PACKAGE_luci-app-passwall=y

#
# Configuration
#
# CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy is not set
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_tuic_client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Geodata is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin is not set
" >> configfiles/template/.config_x86-64

#更新golang到1.25
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.25 feeds/packages/lang/golang

# 禁止进入默认配置
#sed -i "s/make defconfig/#make defconfig/g" build
# 禁止build对argon主题修改
sed -i 's/"$model_argon >/open.png" >/g' build
# 解决ubim uqmi报错
sed -i "s/LUCI_DEPENDS/#LUCI_DEPENDS/g" feeds/luci/protocols/luci-proto-mbim/Makefile
sed -i "s/LUCI_DEPENDS/#LUCI_DEPENDS/g" feeds/luci/protocols/luci-proto-qmi/Makefile

