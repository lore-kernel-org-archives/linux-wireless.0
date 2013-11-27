Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35182 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3K0K2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 05:28:37 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ath9k: Update initvals for AR9300 v2.2
Date: Wed, 27 Nov 2013 15:53:47 +0530
Message-Id: <1385547828-4330-2-git-send-email-sujith@msujith.org> (sfid-20131127_112842_308253_01E9A406)
In-Reply-To: <1385547828-4330-1-git-send-email-sujith@msujith.org>
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 7546b9a..1553395 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -352,7 +352,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
 	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
-	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
+	{0x0000a2d0, 0x00041983, 0x00041983, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a830, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
@@ -378,9 +378,9 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x00009814, 0x9280c00a},
 	{0x00009818, 0x00000000},
 	{0x0000981c, 0x00020028},
-	{0x00009834, 0x6400a290},
+	{0x00009834, 0x6400a190},
 	{0x00009838, 0x0108ecff},
-	{0x0000983c, 0x0d000600},
+	{0x0000983c, 0x14000600},
 	{0x00009880, 0x201fff00},
 	{0x00009884, 0x00001042},
 	{0x000098a4, 0x00200400},
@@ -401,7 +401,7 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x00009d04, 0x40206c10},
 	{0x00009d08, 0x009c4060},
 	{0x00009d0c, 0x9883800a},
-	{0x00009d10, 0x01834061},
+	{0x00009d10, 0x01884061},
 	{0x00009d14, 0x00c0040b},
 	{0x00009d18, 0x00000000},
 	{0x00009e08, 0x0038230c},
@@ -459,7 +459,7 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x0000a3e8, 0x20202020},
 	{0x0000a3ec, 0x20202020},
 	{0x0000a3f0, 0x00000000},
-	{0x0000a3f4, 0x00000246},
+	{0x0000a3f4, 0x00000000},
 	{0x0000a3f8, 0x0c9bd380},
 	{0x0000a3fc, 0x000f0f01},
 	{0x0000a400, 0x8fa91f01},
@@ -644,7 +644,7 @@ static const u32 ar9300Modes_high_ob_db_tx_gain_table_2p2[][5] = {
 	{0x0000a2e0, 0x0000f000, 0x0000f000, 0x03ccc584, 0x03ccc584},
 	{0x0000a2e4, 0x01ff0000, 0x01ff0000, 0x03f0f800, 0x03f0f800},
 	{0x0000a2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
-	{0x0000a410, 0x000050d8, 0x000050d8, 0x000050d9, 0x000050d9},
+	{0x0000a410, 0x000050d4, 0x000050d4, 0x000050d9, 0x000050d9},
 	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
 	{0x0000a504, 0x04002222, 0x04002222, 0x04000002, 0x04000002},
 	{0x0000a508, 0x09002421, 0x09002421, 0x08000004, 0x08000004},
@@ -1086,8 +1086,8 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
 	{0x0000b074, 0x00000000},
 	{0x0000b078, 0x00000000},
 	{0x0000b07c, 0x00000000},
-	{0x0000b080, 0x2a2d2f32},
-	{0x0000b084, 0x21232328},
+	{0x0000b080, 0x23232323},
+	{0x0000b084, 0x21232323},
 	{0x0000b088, 0x19191c1e},
 	{0x0000b08c, 0x12141417},
 	{0x0000b090, 0x07070e0e},
@@ -1385,9 +1385,9 @@ static const u32 ar9300_2p2_mac_core[][2] = {
 	{0x000081f8, 0x00000000},
 	{0x000081fc, 0x00000000},
 	{0x00008240, 0x00100000},
-	{0x00008244, 0x0010f424},
+	{0x00008244, 0x0010f400},
 	{0x00008248, 0x00000800},
-	{0x0000824c, 0x0001e848},
+	{0x0000824c, 0x0001e800},
 	{0x00008250, 0x00000000},
 	{0x00008254, 0x00000000},
 	{0x00008258, 0x00000000},
@@ -1726,14 +1726,14 @@ static const u32 ar9300PciePhy_pll_on_clkreq_disable_L1_2p2[][2] = {
 
 static const u32 ar9300PciePhy_clkreq_enable_L1_2p2[][2] = {
 	/* Addr      allmodes  */
-	{0x00004040, 0x08253e5e},
+	{0x00004040, 0x0825365e},
 	{0x00004040, 0x0008003b},
 	{0x00004044, 0x00000000},
 };
 
 static const u32 ar9300PciePhy_clkreq_disable_L1_2p2[][2] = {
 	/* Addr      allmodes  */
-	{0x00004040, 0x08213e5e},
+	{0x00004040, 0x0821365e},
 	{0x00004040, 0x0008003b},
 	{0x00004044, 0x00000000},
 };
-- 
1.8.4.2

