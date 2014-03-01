Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57793 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaCAURL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:11 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 10/23] ath9k: remove unused beacon_qi
Date: Sat,  1 Mar 2014 21:15:53 +0100
Message-Id: <1393704966-13985-11-git-send-email-linux@rempel-privat.de> (sfid-20140301_214710_065993_6C1B2BB1)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d8dddce..aa4f144 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -420,7 +420,6 @@ struct ath_beacon {
 	struct ieee80211_vif *bslot[ATH_BCBUF];
 	int slottime;
 	int slotupdate;
-	struct ath9k_tx_queue_info beacon_qi;
 	struct ath_descdma bdma;
 	struct ath_txq *cabq;
 	struct list_head bbuf;
-- 
1.9.0

