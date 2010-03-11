Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47389 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0CKVdP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/5] compat-wireless: remove some uneeded header files
Date: Thu, 11 Mar 2010 22:32:46 +0100
Message-Id: <1268343167-2961-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless.h and wext.h must not be shipped with compat-wireless.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 29dd460..af4479a 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -21,7 +21,7 @@ GIT_COMPAT_URL="git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git"
 INCLUDE_NET_BT="hci_core.h l2cap.h bluetooth.h rfcomm.h hci.h"
 NET_BT_DIRS="bluetooth bluetooth/bnep bluetooth/cmtp bluetooth/rfcomm bluetooth/hidp"
 
-INCLUDE_LINUX="ieee80211.h nl80211.h wireless.h"
+INCLUDE_LINUX="ieee80211.h nl80211.h"
 INCLUDE_LINUX="$INCLUDE_LINUX pci_ids.h eeprom_93cx6.h"
 INCLUDE_LINUX="$INCLUDE_LINUX ath9k_platform.h"
 
@@ -32,7 +32,7 @@ INCLUDE_LINUX_SPI="wl12xx.h libertas_spi.h"
 
 # The good new yummy stuff
 INCLUDE_NET="cfg80211.h ieee80211_radiotap.h"
-INCLUDE_NET="$INCLUDE_NET mac80211.h wext.h lib80211.h regulatory.h"
+INCLUDE_NET="$INCLUDE_NET mac80211.h lib80211.h regulatory.h"
 
 # Pretty colors
 GREEN="\033[01;32m"
-- 
1.6.3.3

