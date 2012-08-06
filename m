Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12143 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2HFQnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 12:43:49 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20511.62447.343567.367491@gargle.gargle.HOWL> (sfid-20120806_184353_612641_ECA3D8C5)
Date: Mon, 6 Aug 2012 22:12:23 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3.5.y 1/2] compat-wireless: Update pending-stable patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 .../0001-mac80211-fail-authentication-when-AP-denied-authenti.patch | 4 ++--
 pending-stable/0002-rt2800usb-2001-3c17-is-an-RT3370-device.patch   | 4 ++--
 pending-stable/0004-mac80211-fix-read-outside-array-bounds.patch    | 4 ++--
 pending-stable/0005-mwifiex-correction-in-mcs-index-check.patch     | 4 ++--
 .../0006-rtlwifi-rtl8192cu-Change-buffer-allocation-for-synch.patch | 6 +++---
 .../0007-rtlwifi-rtl8192de-Fix-phy-based-version-calculation.patch  | 4 ++--
 pending-stable/0008-b43-fix-crash-with-OpenFWWF.patch               | 6 +++---
 .../0009-atl1c-fix-issue-of-io-access-mode-for-AR8152-v2.1.patch    | 6 +++---
 8 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/pending-stable/0001-mac80211-fail-authentication-when-AP-denied-authenti.patch b/pending-stable/0001-mac80211-fail-authentication-when-AP-denied-authenti.patch
index 98cfdec..2185734 100644
--- a/pending-stable/0001-mac80211-fail-authentication-when-AP-denied-authenti.patch
+++ b/pending-stable/0001-mac80211-fail-authentication-when-AP-denied-authenti.patch
@@ -15,7 +15,7 @@ Acked-by: Johannes Berg <johannes@sipsolutions.net>
 Cc: stable@vger.kernel.org #3.4
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- net/mac80211/mlme.c |    4 ++--
+ net/mac80211/mlme.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)
 
 diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
@@ -41,5 +41,5 @@ index 04c3063..a2f18b7 100644
  	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
  	run_again(ifmgd, ifmgd->auth_data->timeout);
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0002-rt2800usb-2001-3c17-is-an-RT3370-device.patch b/pending-stable/0002-rt2800usb-2001-3c17-is-an-RT3370-device.patch
index 8796b7e..d5ebe5c 100644
--- a/pending-stable/0002-rt2800usb-2001-3c17-is-an-RT3370-device.patch
+++ b/pending-stable/0002-rt2800usb-2001-3c17-is-an-RT3370-device.patch
@@ -10,7 +10,7 @@ Cc: <stable@vger.kernel.org>
 Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
+ drivers/net/wireless/rt2x00/rt2800usb.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)
 
 diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -35,5 +35,5 @@ index bf78317..20a5040 100644
  	{ USB_DEVICE(0x203d, 0x14a1) },
  	/* Gemtek */
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0004-mac80211-fix-read-outside-array-bounds.patch b/pending-stable/0004-mac80211-fix-read-outside-array-bounds.patch
index af18702..7170bb8 100644
--- a/pending-stable/0004-mac80211-fix-read-outside-array-bounds.patch
+++ b/pending-stable/0004-mac80211-fix-read-outside-array-bounds.patch
@@ -10,7 +10,7 @@ Cc: stable@vger.kernel.org
 Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- net/mac80211/tx.c |    2 +-
+ net/mac80211/tx.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)
 
 diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
@@ -27,5 +27,5 @@ index e453212..85cf32d 100644
  	skb_set_mac_header(skb, 0);
  	skb_set_network_header(skb, 0);
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0005-mwifiex-correction-in-mcs-index-check.patch b/pending-stable/0005-mwifiex-correction-in-mcs-index-check.patch
index 4caf03a..9e8d541 100644
--- a/pending-stable/0005-mwifiex-correction-in-mcs-index-check.patch
+++ b/pending-stable/0005-mwifiex-correction-in-mcs-index-check.patch
@@ -15,7 +15,7 @@ Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
 Signed-off-by: Bing Zhao <bzhao@marvell.com>
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- drivers/net/wireless/mwifiex/cfg80211.c |    4 ++--
+ drivers/net/wireless/mwifiex/cfg80211.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)
 
 diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -35,5 +35,5 @@ index 5c7fd18..76b5c0f 100644
  		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
  		/* 40MHz rate */
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0006-rtlwifi-rtl8192cu-Change-buffer-allocation-for-synch.patch b/pending-stable/0006-rtlwifi-rtl8192cu-Change-buffer-allocation-for-synch.patch
index b0e02f9..ddc99e6 100644
--- a/pending-stable/0006-rtlwifi-rtl8192cu-Change-buffer-allocation-for-synch.patch
+++ b/pending-stable/0006-rtlwifi-rtl8192cu-Change-buffer-allocation-for-synch.patch
@@ -16,8 +16,8 @@ Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
 Cc: Stable <stable@vger.kernel.org>
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- drivers/net/wireless/rtlwifi/usb.c  |   14 +++++++++++---
- drivers/net/wireless/rtlwifi/wifi.h |    1 +
+ drivers/net/wireless/rtlwifi/usb.c  | 14 +++++++++++---
+ drivers/net/wireless/rtlwifi/wifi.h |  1 +
  2 files changed, 12 insertions(+), 3 deletions(-)
 
 diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
@@ -71,5 +71,5 @@ index bd816ae..cdaa21f 100644
  	/*Dual mac*/
  	spinlock_t cck_and_rw_pagea_lock;
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0007-rtlwifi-rtl8192de-Fix-phy-based-version-calculation.patch b/pending-stable/0007-rtlwifi-rtl8192de-Fix-phy-based-version-calculation.patch
index 60d8dae..31a1ef0 100644
--- a/pending-stable/0007-rtlwifi-rtl8192de-Fix-phy-based-version-calculation.patch
+++ b/pending-stable/0007-rtlwifi-rtl8192de-Fix-phy-based-version-calculation.patch
@@ -22,7 +22,7 @@ Cc: Stable <stable@vger.kernel.org> [v3.2+]
 Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    6 +++---
+ drivers/net/wireless/rtlwifi/rtl8192de/phy.c | 6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)
 
 diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -55,5 +55,5 @@ index 18380a7..4420312 100644
  		if (rtlhal->interfaceindex == 0) {
  			rtlhal->bandset = BAND_ON_5G;
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0008-b43-fix-crash-with-OpenFWWF.patch b/pending-stable/0008-b43-fix-crash-with-OpenFWWF.patch
index 079b2fa..4e261cc 100644
--- a/pending-stable/0008-b43-fix-crash-with-OpenFWWF.patch
+++ b/pending-stable/0008-b43-fix-crash-with-OpenFWWF.patch
@@ -17,8 +17,8 @@ Signed-off-by: Johannes Berg <johannes.berg@intel.com>
 Cc: stable@vger.kernel.org (depends on commit a6f38ac3)
 Signed-off-by: John W. Linville <linville@tuxdriver.com>
 ---
- drivers/net/wireless/b43/b43.h  |    7 -------
- drivers/net/wireless/b43/main.c |   32 ++++++++++----------------------
+ drivers/net/wireless/b43/b43.h  |  7 -------
+ drivers/net/wireless/b43/main.c | 32 ++++++++++----------------------
  2 files changed, 10 insertions(+), 29 deletions(-)
 
 diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
@@ -126,5 +126,5 @@ index acd03a4..3e5cd8d 100644
  		ieee80211_unregister_hw(wl->hw);
  	}
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
diff --git a/pending-stable/0009-atl1c-fix-issue-of-io-access-mode-for-AR8152-v2.1.patch b/pending-stable/0009-atl1c-fix-issue-of-io-access-mode-for-AR8152-v2.1.patch
index e84d148..d38be01 100644
--- a/pending-stable/0009-atl1c-fix-issue-of-io-access-mode-for-AR8152-v2.1.patch
+++ b/pending-stable/0009-atl1c-fix-issue-of-io-access-mode-for-AR8152-v2.1.patch
@@ -12,8 +12,8 @@ Cc: stable <stable@vger.kernel.org>
 Signed-off-by: xiong <xiong@qca.qualcomm.com>
 Signed-off-by: David S. Miller <davem@davemloft.net>
 ---
- drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |    5 +++++
- drivers/net/ethernet/atheros/atl1c/atl1c_main.c |   16 +++++++++++++++-
+ drivers/net/ethernet/atheros/atl1c/atl1c_hw.h   |  5 +++++
+ drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 16 +++++++++++++++-
  2 files changed, 20 insertions(+), 1 deletion(-)
 
 diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -81,5 +81,5 @@ index 36d3783..1bf5bbf 100644
  	/* before link up, we assume hibernate is true */
  	hw->hibernate = true;
 -- 
-1.7.10.rc1.22.gf5241
+1.7.11.4
 
-- 
1.7.11.4

