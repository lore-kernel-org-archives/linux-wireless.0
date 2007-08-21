Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbXHUPPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:15:01 -0400
Message-Id: <20070821150044.408701000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, developers@islsm.org
Subject: [PATCH 12/27] p54: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: developers@islsm.org

---
 drivers/net/wireless/p54common.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/p54common.c	2007-08-21 14:39:00.575923881 +0200
+++ wireless-dev/drivers/net/wireless/p54common.c	2007-08-21 14:40:13.525923881 +0200
@@ -893,9 +893,7 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->modes[0].channels = priv->channels;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		    IEEE80211_HW_RX_INCLUDES_FCS |
-		    IEEE80211_HW_WEP_INCLUDE_IV |
-		    IEEE80211_HW_DATA_NULLFUNC_ACK; /* TODO: check */
-		    /* IEEE80211_HW_MONITOR_DURING_OPER FIXME: check */
+		    IEEE80211_HW_WEP_INCLUDE_IV;
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 100;
 

-- 

