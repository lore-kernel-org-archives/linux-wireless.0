Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36248 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbaEIMnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:43:00 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so2615528eek.16
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/7] ath10k: remove old unused defines
Date: Fri,  9 May 2014 14:35:57 +0200
Message-Id: <1399638957-20449-8-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144310_771565_5ED85AEB)
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These aren't used anywhere anymore.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 01f1830..1128b5d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -37,7 +37,6 @@
 #define WO(_f)      ((_f##_OFFSET) >> 2)
 
 #define ATH10K_SCAN_ID 0
-#define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
 #define ATH10K_NUM_CHANS 38
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9e3b16f..e9608e7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3551,8 +3551,6 @@ exit:
 	return ret;
 }
 
-#define ATH10K_ROC_TIMEOUT_HZ (2*HZ)
-
 static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_channel *chan,
-- 
1.8.5.3

