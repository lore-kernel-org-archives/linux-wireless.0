Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48959 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 09/11] ath9k_hw: remove spur related unused defines
Date: Sat, 14 Dec 2013 18:03:43 +0100
Message-Id: <1387040625-38114-9-git-send-email-nbd@openwrt.org> (sfid-20131214_180402_032282_32B219E7)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2ef9d24..4e3b73b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -292,8 +292,6 @@ struct ath9k_ops_config {
 	int serialize_regmode;
 	bool rx_intr_mitigation;
 	bool tx_intr_mitigation;
-#define AR_SPUR_5413_1      	1640
-#define AR_SPUR_5413_2      	1200
 #define AR_NO_SPUR      	0x8000
 #define AR_BASE_FREQ_2GHZ   	2300
 #define AR_BASE_FREQ_5GHZ   	4900
-- 
1.8.3.4 (Apple Git-47)

