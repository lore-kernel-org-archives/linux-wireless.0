Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:33662
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751440Ab2LJCvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 21:51:03 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k_hw: Update intivals for AR9340
Date: Mon, 10 Dec 2012 08:20:27 +0530
Message-Id: <1355107827-304-1-git-send-email-sujith@msujith.org> (sfid-20121210_035110_625085_824EECD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
index 1d8235e..f69d292 100644
--- a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
@@ -211,6 +211,8 @@ static const u32 ar9340_1p0_radio_core_40M[][2] = {
 	{0x0001609c, 0x02566f3a},
 	{0x000160ac, 0xa4647c00},
 	{0x000160b0, 0x01885f5a},
+	{0x00008244, 0x0010f400},
+	{0x0000824c, 0x0001e800},
 };
 
 #define ar9340_1p0_mac_postamble ar9300_2p2_mac_postamble
@@ -1273,9 +1275,9 @@ static const u32 ar9340_1p0_mac_core[][2] = {
 	{0x000081f8, 0x00000000},
 	{0x000081fc, 0x00000000},
 	{0x00008240, 0x00100000},
-	{0x00008244, 0x0010f424},
+	{0x00008244, 0x0010f3d7},
 	{0x00008248, 0x00000800},
-	{0x0000824c, 0x0001e848},
+	{0x0000824c, 0x0001e7ae},
 	{0x00008250, 0x00000000},
 	{0x00008254, 0x00000000},
 	{0x00008258, 0x00000000},
-- 
1.8.0.1

