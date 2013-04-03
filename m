Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38793 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762099Ab3DCQct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:32:49 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: siwu@hrz.tu-chemnitz.de, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [TESTING-QH 1/2] REMOVEME: shorten time for NOP and CAC
Date: Wed,  3 Apr 2013 18:32:38 +0200
Message-Id: <1365006759-16779-2-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183255_307256_5A779464)
In-Reply-To: <1365006759-16779-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1365006759-16779-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

This is for testing only and to save you from waiting half an hour for a NOP.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 include/net/cfg80211.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bdba9b6..6046cf3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -126,8 +126,8 @@ enum ieee80211_channel_flags {
 #define IEEE80211_CHAN_NO_HT40 \
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
-#define IEEE80211_DFS_MIN_CAC_TIME_MS		60000
-#define IEEE80211_DFS_MIN_NOP_TIME_MS		(30 * 60 * 1000)
+#define IEEE80211_DFS_MIN_CAC_TIME_MS		4000
+#define IEEE80211_DFS_MIN_NOP_TIME_MS		(6000)
 
 /**
  * struct ieee80211_channel - channel definition
-- 
1.7.4.1

