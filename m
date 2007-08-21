Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761462AbXHUPCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:02:48 -0400
Message-Id: <20070821150043.996531000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/27] rtl8187: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>

---
 drivers/net/wireless/rtl8187_dev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/rtl8187_dev.c	2007-08-21 14:39:00.825923881 +0200
+++ wireless-dev/drivers/net/wireless/rtl8187_dev.c	2007-08-21 14:40:12.535923881 +0200
@@ -606,8 +606,7 @@ static int __devinit rtl8187_probe(struc
 	priv->mode = IEEE80211_IF_TYPE_MGMT;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_WEP_INCLUDE_IV |
-		     IEEE80211_HW_DATA_NULLFUNC_ACK;
+		     IEEE80211_HW_WEP_INCLUDE_IV;
 	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
 	dev->queues = 1;
 	dev->max_rssi = 65;

-- 

