Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45224 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3EPRUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 13:20:15 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] initvals: Update AR9485 initvals
Date: Thu, 16 May 2013 22:47:46 +0530
Message-Id: <1368724666-23299-1-git-send-email-sujith@msujith.org> (sfid-20130516_192018_544691_EB99AF63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Disable HW peak detector calibration.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9485_initvals.h | 2 +-
 tools/initvals/checksums.txt     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/initvals/ar9485_initvals.h b/tools/initvals/ar9485_initvals.h
index a3710f3..0ec1ca7 100644
--- a/tools/initvals/ar9485_initvals.h
+++ b/tools/initvals/ar9485_initvals.h
@@ -874,7 +874,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x000002a0, 0x000002a0},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 551c3ba..49158f3 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -171,7 +171,7 @@ d9a90632a00a7b417154173b947dfffdeab23e51        ar9485Common_wo_xlna_rx_gain_1_1
 b8bc19098aa0ac38cf74ca4747e28ce6bad14fa1        ar9485_1_1_pcie_phy_clkreq_enable_L1
 7e1adfdb0f6a6dbbbe901d8eb019a425edfa58a6        ar9485_1_1_soc_preamble
 f247bc63c9a632092b94d1af1526650753b77a60        ar9485_fast_clock_1_1_baseband_postamble
-f1b452dfb558a755d9004241c29b43abd3332359        ar9485_1_1_baseband_postamble
+2c8e4cc712b0dc78bdeee997023356cb41a0b9b2        ar9485_1_1_baseband_postamble
 c8016c349304ed85842783f04f01f40a0cf4468f        ar9485_1_1_pcie_phy_clkreq_disable_L1
 f5bb0f6a25e512b85039e8c49ebc6555ff27ac4d        ar9485_1_1_radio_postamble
 be2a6982ce450a3e03b1593199395599778297b0        ar9485_1_1_mac_core
-- 
1.8.2.3

