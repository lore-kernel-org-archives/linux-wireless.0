Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45424 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab3FREqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:46:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] initvals: Update inivals for AR9462 2.0
Date: Tue, 18 Jun 2013 10:13:08 +0530
Message-Id: <1371530590-15676-1-git-send-email-sujith@msujith.org> (sfid-20130618_064613_978303_D2D59C8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9462_2p0_initvals.h | 2 +-
 tools/initvals/checksums.txt         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/initvals/ar9462_2p0_initvals.h b/tools/initvals/ar9462_2p0_initvals.h
index 999ab08..f00e945 100644
--- a/tools/initvals/ar9462_2p0_initvals.h
+++ b/tools/initvals/ar9462_2p0_initvals.h
@@ -78,7 +78,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 551c3ba..e3632c8 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -139,7 +139,7 @@ ca6088034f339ea8f106f7f034d34baafec0c0ca        ar9340Modes_high_ob_db_tx_gain_t
 1b9f617ab8c10ec0760e81fe61d469692f2acc29        ar9340_1p0_soc_preamble
 d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_modes_fast_clock_2p0
 222ed8213d3ffb0d12cf4c7019bdfd874e45c7d7        ar9462_pciephy_clkreq_enable_L1_2p0
-efb4c74c657dbc49ab80dd1d42a5b8e6ff0c3651        ar9462_2p0_baseband_postamble
+d7a2102c22264c288fa3d9de27e5ae84b8f3812e        ar9462_2p0_baseband_postamble
 d0f7aff1a1ab7e6f6bbda0da067714459341ce5f        ar9462_common_rx_gain_table_2p0
 2fbe90336971cd66f0264c0cc57605c2de069d5f        ar9462_pciephy_clkreq_disable_L1_2p0
 a3173672141a2ac797e660228d41a609f9ab2c4c        ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
-- 
1.8.3.1

