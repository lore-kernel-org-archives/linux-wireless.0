Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54382 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaCAURJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:09 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 12/23] ath9k-common: add nexttbtt and intval to ath_beacon_config
Date: Sat,  1 Mar 2014 21:15:55 +0100
Message-Id: <1393704966-13985-13-git-send-email-linux@rempel-privat.de> (sfid-20140301_214710_421688_52FF4623)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 8deed82..eccc718 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -53,6 +53,8 @@ struct ath_beacon_config {
 	u8 dtim_count;
 	bool enable_beacon;
 	bool ibss_creator;
+	u32 nexttbtt;
+	u32 intval;
 };
 
 bool ath9k_cmn_rx_accept(struct ath_common *common,
-- 
1.9.0

