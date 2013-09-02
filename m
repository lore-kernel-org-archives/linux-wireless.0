Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:34121 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3IBFr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 01:47:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] ath9k: Update initvals for AR9565 1.0
Date: Mon,  2 Sep 2013 11:14:00 +0530
Message-Id: <1378100645-29868-1-git-send-email-sujith@msujith.org> (sfid-20130902_074813_489091_88E1A380)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
index e85a8b0..03ecc07 100644
--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
@@ -272,9 +272,9 @@ static const u32 ar9565_1p0_baseband_core[][2] = {
 	{0x0000a398, 0x001f0e0f},
 	{0x0000a39c, 0x0075393f},
 	{0x0000a3a0, 0xb79f6427},
-	{0x0000a3a4, 0x00000000},
-	{0x0000a3a8, 0xaaaaaaaa},
-	{0x0000a3ac, 0x3c466478},
+	{0x0000a3a4, 0x00000011},
+	{0x0000a3a8, 0xaaaaaa6e},
+	{0x0000a3ac, 0x3c466455},
 	{0x0000a3c0, 0x20202020},
 	{0x0000a3c4, 0x22222220},
 	{0x0000a3c8, 0x20200020},
@@ -295,11 +295,11 @@ static const u32 ar9565_1p0_baseband_core[][2] = {
 	{0x0000a404, 0x00000000},
 	{0x0000a408, 0x0e79e5c6},
 	{0x0000a40c, 0x00820820},
-	{0x0000a414, 0x1ce739ce},
+	{0x0000a414, 0x1ce739c5},
 	{0x0000a418, 0x2d001dce},
-	{0x0000a41c, 0x1ce739ce},
+	{0x0000a41c, 0x1ce739c5},
 	{0x0000a420, 0x000001ce},
-	{0x0000a424, 0x1ce739ce},
+	{0x0000a424, 0x1ce739c5},
 	{0x0000a428, 0x000001ce},
 	{0x0000a42c, 0x1ce739ce},
 	{0x0000a430, 0x1ce739ce},
@@ -351,9 +351,9 @@ static const u32 ar9565_1p0_baseband_postamble[][5] = {
 	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3379605e, 0x33795d5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003a4, 0x000003a4},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946222, 0xcf946222},
+	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946220, 0xcf946220},
 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -452,6 +452,7 @@ static const u32 ar9565_1p0_Common_rx_gain_table[][2] = {
 	/* Addr      allmodes  */
 	{0x00004050, 0x00300300},
 	{0x0000406c, 0x00100000},
+	{0x00009e20, 0x000003b6},
 	{0x0000a000, 0x00010000},
 	{0x0000a004, 0x00030002},
 	{0x0000a008, 0x00050004},
-- 
1.8.4

