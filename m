Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49668 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3IBFrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 01:47:42 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] initvals: AR9565 1.0 update
Date: Mon,  2 Sep 2013 11:13:55 +0530
Message-Id: <1378100635-29507-1-git-send-email-sujith@msujith.org> (sfid-20130902_074746_868913_D7AFE937)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9565_1p0_initvals.h | 17 +++++++++--------
 tools/initvals/checksums.txt         |  6 +++---
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/initvals/ar9565_1p0_initvals.h b/tools/initvals/ar9565_1p0_initvals.h
index e85a8b0..03ecc07 100644
--- a/tools/initvals/ar9565_1p0_initvals.h
+++ b/tools/initvals/ar9565_1p0_initvals.h
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
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 63616c6..e39c382 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -220,13 +220,13 @@ b836a622916e66da6a23c9cd34a7d933571ff6db        ar955x_1p0_modes_no_xpa_tx_gain_
 d9efd1c575ac43d60c310d717c59617a5323c111        ar955x_1p0_modes_fast_clock
 839b2486a70775db100fca6421860d4922fbf945        ar9565_1p0_mac_core
 c8dc777b012068116cd5282aade8eb460f397d20        ar9565_1p0_mac_postamble
-26297fd915614c1f9ad22fb611335a2ac715a2d9        ar9565_1p0_baseband_core
-e719a3c597fa3511cfb436aeb4cfdda3b5949685        ar9565_1p0_baseband_postamble
+0bebd5782645e1c2dfc1d2ece29acc62c644dff6        ar9565_1p0_baseband_core
+91bb5a283b964a2a3f1a1d4af4e8aa5a6d8e52a6        ar9565_1p0_baseband_postamble
 98708e6c8cde013777cd5c5c9ded6dfe038b652f        ar9565_1p0_radio_core
 bc722e44e8c7039983b485fc099275c6629974cf        ar9565_1p0_radio_postamble
 524fae156c2942a28c62603dac8f9ee99ff0e25a        ar9565_1p0_soc_preamble
 b045882e6e5b3f54d9eed19022abe6a44bc04e73        ar9565_1p0_soc_postamble
-6af86113836112173aab7266f22acee984d956a9        ar9565_1p0_Common_rx_gain_table
+e9bca7db26287525c935043ca7c3abb0375ecca8        ar9565_1p0_Common_rx_gain_table
 4bf703cdebf0bfb9ad867cb53b79d6c3957b6f91        ar9565_1p0_Modes_lowest_ob_db_tx_gain_table
 a3173672141a2ac797e660228d41a609f9ab2c4c        ar9565_1p0_pciephy_clkreq_disable_L1
 6db24dff7f419466d4734d59063314b9e52d4640        ar9565_1p0_modes_fast_clock
-- 
1.8.4

