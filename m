Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:12597 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab1AYEPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:15:46 -0500
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-064998944
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:15:44 +0900 (JST)
Subject: [PATCH 5/6] ath9k: Remove unused IEEE80211_WEP_NKID
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 25 Jan 2011 13:15:43 +0900
Message-ID: <20110125041543.6944.64829.stgit@localhost6.localdomain6>
In-Reply-To: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_WEP_NKID is not used in ath9k any more since the key handling code
has been moved to ath/.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/common.h |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index dab0271..3472b84 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -537,7 +537,6 @@ struct ath_ant_comb {
 #define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
 #define ATH_MAX_SW_RETRIES      10
 #define ATH_CHAN_MAX            255
-#define IEEE80211_WEP_NKID      4       /* number of key ids */
 
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 #define ATH_RATE_DUMMY_MARKER   0
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index a126bdd..4c7020b 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -23,8 +23,6 @@
 
 /* Common header for Atheros 802.11n base driver cores */
 
-#define IEEE80211_WEP_NKID 4
-
 #define WME_NUM_TID             16
 #define WME_BA_BMP_SIZE         64
 #define WME_MAX_BA              WME_BA_BMP_SIZE

