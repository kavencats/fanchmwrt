#!/bin/bash
#set -e

#DTS_DIR="target/linux/mediatek/dts"
#MK="target/linux/mediatek/image/filogic.mk"

PKG_DIR="package/custom"
mkdir -p "$PKG_DIR"

# 若 feeds 里没有 adguardhome 核心，拉第三方
if ! ./scripts/feeds list -n 2>/dev/null | grep -qx 'adguardhome'; then
  echo ">> 拉取 adguardhome 核心包"
  git clone --depth=1 https://github.com/AoThen/luci-app-adguardhome.git \
      "$PKG_DIR/luci-app-adguardhome"
  # AoThen 版自带核心下载逻辑（在线拉 AdGuardHome 二进制 + UPX 压缩）
fi

# 若已存在 256mb dts 就跳过
#if [ ! -f "$DTS_DIR/mt7981b-cudy-tr3000-v1-256mb.dts" ]; then
#  echo ">> 注入 256MB DTS"
#  cp "$GITHUB_WORKSPACE/builder/files/mt7981b-cudy-tr3000-v1-256mb.dts" \
#     "$DTS_DIR/"
#  # 在 filogic.mk 里追加 profile（按你源码实际变量名微调）
#  cat >> "$MK" <<'EOF'

#define Device/cudy_tr3000-256mb-v1
#  $(Device/mediatek/filogic-common)
#  DEVICE_MODEL := Cudy TR3000
#  DEVICE_VARIANT := 256MB v1
#  DEVICE_DTS := mt7981b-cudy-tr3000-v1-256mb
#  IMAGE_SIZE := 252000k
#endef
#TARGET_DEVICES += cudy_tr3000-256mb-v1
#EOF
#fi

# 顺手固定 LAN IP，方便刷完直接进
sed -i 's/192.168.1.1/192.168.3.1/g' package/base-files/files/bin/config_generate

echo ">> diy-part2 done"
