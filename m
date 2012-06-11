Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55888 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2FKEtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 00:49:45 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20437.30884.885802.512693@gargle.gargle.HOWL> (sfid-20120611_064948_822391_224E6372)
Date: Mon, 11 Jun 2012 10:18:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Update initvals for AR9462
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust quick_drop value in the baseband AGC register to
improve RX in HT20 mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 4a93e15..8f406ff 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -52,7 +52,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e04, 0x001c2020, 0x001c2020, 0x001c2020, 0x001c2020},
 	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000d8},
 	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec86d2e},
-	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3376605e, 0x33795d5e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3376605e, 0x32395d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
-- 
1.7.10.4

