Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52078 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZCFOcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 09:32:46 -0500
Received: by mail-fx0-f176.google.com with SMTP id 24so402680fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 06:32:45 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Subject: [PATCH 3/3] ipw2x00: remove obsolete enums
Date: Fri, 6 Mar 2009 15:32:31 +0100
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903061532.31502.Helmut.Schaa@gmx.de> (sfid-20090306_153248_512509_6943DE81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove obsolete enums from ipw2x00/ieee80211.h, they are not used anymore.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/ipw2x00/ieee80211.h b/drivers/net/wireless/ipw2x00/ieee80211.h
index 299e29f..f82435e 100644
--- a/drivers/net/wireless/ipw2x00/ieee80211.h
+++ b/drivers/net/wireless/ipw2x00/ieee80211.h
@@ -164,23 +164,6 @@ struct ieee80211_snap_hdr {
 #define WLAN_GET_SEQ_FRAG(seq) ((seq) & IEEE80211_SCTL_FRAG)
 #define WLAN_GET_SEQ_SEQ(seq)  (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 
-/* Action categories - 802.11h */
-enum ieee80211_actioncategories {
-	WLAN_ACTION_SPECTRUM_MGMT = 0,
-	/* Reserved 1-127  */
-	/* Error    128-255 */
-};
-
-/* Action details - 802.11h */
-enum ieee80211_actiondetails {
-	WLAN_ACTION_CATEGORY_MEASURE_REQUEST = 0,
-	WLAN_ACTION_CATEGORY_MEASURE_REPORT = 1,
-	WLAN_ACTION_CATEGORY_TPC_REQUEST = 2,
-	WLAN_ACTION_CATEGORY_TPC_REPORT = 3,
-	WLAN_ACTION_CATEGORY_CHANNEL_SWITCH = 4,
-	/* 5 - 255 Reserved */
-};
-
 #define IEEE80211_STATMASK_SIGNAL (1<<0)
 #define IEEE80211_STATMASK_RSSI (1<<1)
 #define IEEE80211_STATMASK_NOISE (1<<2)
