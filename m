Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52788 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3KNKAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 05:00:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Update AR9462 2.1 initvals
Date: Thu, 14 Nov 2013 15:25:23 +0530
Message-Id: <1384422923-9078-1-git-send-email-sujith@msujith.org> (sfid-20131114_110004_126271_551826E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
index bec18bf..0fcce07 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
@@ -361,7 +361,7 @@ static const u32 ar9462_2p1_baseband_postamble[][5] = {
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3236605e, 0x32365a5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
 	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
@@ -400,7 +400,7 @@ static const u32 ar9462_2p1_baseband_postamble[][5] = {
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x00100000},
 	{0x0000ae18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000ae1c, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
-	{0x0000ae20, 0x000001b5, 0x000001b5, 0x000001ce, 0x000001ce},
+	{0x0000ae20, 0x000001a6, 0x000001a6, 0x000001aa, 0x000001aa},
 	{0x0000b284, 0x00000000, 0x00000000, 0x00000550, 0x00000550},
 };
 
@@ -472,7 +472,7 @@ static const u32 ar9462_2p1_radio_postamble[][5] = {
 
 static const u32 ar9462_2p1_soc_preamble[][2] = {
 	/* Addr      allmodes  */
-	{0x000040a4, 0x00a0c1c9},
+	{0x000040a4, 0x00a0c9c9},
 	{0x00007020, 0x00000000},
 	{0x00007034, 0x00000002},
 	{0x00007038, 0x000004c2},
-- 
1.8.4.2

