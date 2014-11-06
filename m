Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58390 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaKFHyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:41 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 17/21] ath9k_htc: add struct ath_spec_scan_priv to ath9k_htc_priv
Date: Thu,  6 Nov 2014 08:53:34 +0100
Message-Id: <1415260418-14321-18-git-send-email-linux@rempel-privat.de> (sfid-20141106_085453_844291_2CCD5D42)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 09a5d72..1f019aa 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -481,6 +481,7 @@ struct ath9k_htc_priv {
 	unsigned long op_flags;
 
 	struct ath9k_hw_cal_data caldata;
+	struct ath_spec_scan_priv spec_priv;
 
 	spinlock_t beacon_lock;
 	struct ath_beacon_config cur_beacon_conf;
-- 
1.9.1

