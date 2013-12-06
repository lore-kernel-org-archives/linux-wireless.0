Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58361 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3LFLDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:03:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/16] ath9k: Update mac_postamble for AR9003 family
Date: Fri,  6 Dec 2013 16:28:41 +0530
Message-Id: <1386327534-31105-4-git-send-email-sujith@msujith.org> (sfid-20131206_120350_637035_8B64354B)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Enable the ALWAYS_KEYSEARCH bit in the initvals. Currently
this is done in the driver, but adding this to the initvals
makes it easier to be in sync with the INI files given
by the systems engineering team.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 97b4bd1..7243674 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -303,7 +303,7 @@ static const u32 ar9300_2p2_mac_postamble[][5] = {
 	{0x000010b0, 0x00000e60, 0x00001cc0, 0x00007c70, 0x00003e38},
 	{0x00008014, 0x03e803e8, 0x07d007d0, 0x10801600, 0x08400b00},
 	{0x0000801c, 0x128d8027, 0x128d804f, 0x12e00057, 0x12e0002b},
-	{0x00008120, 0x08f04800, 0x08f04800, 0x08f04810, 0x08f04810},
+	{0x00008120, 0x18f04800, 0x18f04800, 0x18f04810, 0x18f04810},
 	{0x000081d0, 0x00003210, 0x00003210, 0x0000320a, 0x0000320a},
 	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
 };
-- 
1.8.4.2

