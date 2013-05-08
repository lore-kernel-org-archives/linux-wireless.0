Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56265 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3EHRSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 13:18:55 -0400
Received: by mail-pd0-f176.google.com with SMTP id x10so1383019pdj.35
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 10:18:55 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath9k <ath9k-devel@lists.ath9k.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 2/3] ath9k_htc: Claim support for mgmt frame protection
Date: Wed,  8 May 2013 10:16:47 -0700
Message-Id: <1368033408-3994-2-git-send-email-thomas@cozybit.com> (sfid-20130508_191858_622127_456BF9CA)
In-Reply-To: <1368033408-3994-1-git-send-email-thomas@cozybit.com>
References: <1368033408-3994-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Advertise support for management frame protection in hardware.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 6eb4199..59f6436 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -722,6 +722,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		IEEE80211_HW_MFP_CAPABLE |
 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	hw->wiphy->interface_modes =
-- 
1.7.10.4

