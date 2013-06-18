Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47564 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3FRKPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 06:15:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Add initvals required for CUS217
Date: Tue, 18 Jun 2013 15:42:37 +0530
Message-Id: <1371550358-5920-2-git-send-email-sujith@msujith.org> (sfid-20130618_121546_447415_E36C5CF9)
In-Reply-To: <1371550358-5920-1-git-send-email-sujith@msujith.org>
References: <1371550358-5920-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index bcd0cae..1d6b705 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -1714,4 +1714,19 @@ static const u32 ar9462_2p0_5g_xlna_only_rxgain[][2] = {
 	{0x0000b1fc, 0x00000196},
 };
 
+static const u32 ar9462_2p0_baseband_core_mix_rxgain[][2] = {
+	/* Addr      allmodes  */
+	{0x00009fd0, 0x0a2d6b93},
+};
+
+static const u32 ar9462_2p0_baseband_postamble_mix_rxgain[][5] = {
+	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
+	{0x00009820, 0x206a022e, 0x206a022e, 0x206a01ae, 0x206a01ae},
+	{0x00009824, 0x63c640de, 0x5ac640d0, 0x63c640da, 0x63c640da},
+	{0x00009828, 0x0796be89, 0x0696b081, 0x0916be81, 0x0916be81},
+	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000d8, 0x6c4000d8},
+	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec86d2e, 0x7ec86d2e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3236605e, 0x32395c5e},
+};
+
 #endif /* INITVALS_9462_2P0_H */
-- 
1.8.3.1

