Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57977 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3ICFCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:02:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] initvals: Update AR9485 1.1 initvals
Date: Tue,  3 Sep 2013 10:28:38 +0530
Message-Id: <1378184318-1169-4-git-send-email-sujith@msujith.org> (sfid-20130903_070237_580347_C8153158)
In-Reply-To: <1378184318-1169-1-git-send-email-sujith@msujith.org>
References: <1378184318-1169-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This fixes issues with ETSI/CCA compliance.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9485_initvals.h | 61 ++++++++++++++++++++--------------------
 tools/initvals/checksums.txt     | 12 ++++----
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/tools/initvals/ar9485_initvals.h b/tools/initvals/ar9485_initvals.h
index 4b37ced..6f899c6 100644
--- a/tools/initvals/ar9485_initvals.h
+++ b/tools/initvals/ar9485_initvals.h
@@ -44,6 +44,7 @@ static const u32 ar9485Common_wo_xlna_rx_gain_1_1[][2] = {
 	{0x00009e00, 0x037216a0},
 	{0x00009e04, 0x00182020},
 	{0x00009e18, 0x00000000},
+	{0x00009e20, 0x000003a8},
 	{0x00009e2c, 0x00004121},
 	{0x00009e44, 0x02282324},
 	{0x0000a000, 0x00060005},
@@ -184,7 +185,7 @@ static const u32 ar9485Modes_high_power_tx_gain_1_1[][5] = {
 	{0x0000a2e0, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
 	{0x0000a2e4, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
 	{0x0000a2e8, 0x00000000, 0x00000000, 0xfe2d3552, 0xfe2d3552},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d8, 0x000050d8},
+	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050da, 0x000050da},
 	{0x0000a458, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a500, 0x00022200, 0x00022200, 0x00000000, 0x00000000},
 	{0x0000a504, 0x05062002, 0x05062002, 0x04000002, 0x04000002},
@@ -210,14 +211,14 @@ static const u32 ar9485Modes_high_power_tx_gain_1_1[][5] = {
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
 	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x62001eee, 0x62001eee},
+	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x66001ff6, 0x66001ff6},
+	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
 	{0x0000a580, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a584, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a588, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -372,7 +373,7 @@ static const u32 ar9485Modes_high_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a2e0, 0x00000000, 0x00000000, 0xffc63a84, 0xffc63a84},
 	{0x0000a2e4, 0x00000000, 0x00000000, 0xfe0fc000, 0xfe0fc000},
 	{0x0000a2e8, 0x00000000, 0x00000000, 0xfff00000, 0xfff00000},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d8, 0x000050d8},
+	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050da, 0x000050da},
 	{0x0000a458, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a500, 0x00022200, 0x00022200, 0x00000000, 0x00000000},
 	{0x0000a504, 0x05062002, 0x05062002, 0x04000002, 0x04000002},
@@ -398,14 +399,14 @@ static const u32 ar9485Modes_high_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x57001ce9, 0x57001ce9},
 	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x5a001ceb, 0x5a001ceb},
 	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
-	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x5e001eeb, 0x5e001eeb},
+	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x62001eee, 0x62001eee},
+	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x66001ff6, 0x66001ff6},
+	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
+	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x66001ff6, 0x66001ff6},
 	{0x0000a580, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a584, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a588, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -654,7 +655,7 @@ static const u32 ar9485Modes_green_spur_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a2e0, 0x00000000, 0x00000000, 0xffc98634, 0xffc98634},
 	{0x0000a2e4, 0x00000000, 0x00000000, 0xfff60780, 0xfff60780},
 	{0x0000a2e8, 0x00000000, 0x00000000, 0xfffff800, 0xfffff800},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d7, 0x000050d7},
+	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
 	{0x0000a458, 0x80000000, 0x80000000, 0x80000000, 0x80000000},
 	{0x0000a500, 0x00022200, 0x00022200, 0x00000006, 0x00000006},
 	{0x0000a504, 0x05062002, 0x05062002, 0x03000201, 0x03000201},
@@ -679,15 +680,15 @@ static const u32 ar9485Modes_green_spur_ob_db_tx_gain_1_1[][5] = {
 	{0x0000a550, 0x7703ff0b, 0x7703ff0b, 0x58000ef1, 0x58000ef1},
 	{0x0000a554, 0x7d06ffcb, 0x7d06ffcb, 0x5c000ef3, 0x5c000ef3},
 	{0x0000a558, 0x8407ff0b, 0x8407ff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x62000ef6, 0x62000ef6},
-	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x62000ef6, 0x62000ef6},
-	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x62000ef6, 0x62000ef6},
-	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x62000ef6, 0x62000ef6},
+	{0x0000a55c, 0x8907ffcb, 0x8907ffcb, 0x66001ff0, 0x66001ff0},
+	{0x0000a560, 0x900fff0b, 0x900fff0b, 0x68001ff6, 0x68001ff6},
+	{0x0000a564, 0x960fffcb, 0x960fffcb, 0x68001ff6, 0x68001ff6},
+	{0x0000a568, 0x9c1fff0b, 0x9c1fff0b, 0x68001ff6, 0x68001ff6},
+	{0x0000a56c, 0x9c1fff0b, 0x9c1fff0b, 0x68001ff6, 0x68001ff6},
+	{0x0000a570, 0x9c1fff0b, 0x9c1fff0b, 0x68001ff6, 0x68001ff6},
+	{0x0000a574, 0x9c1fff0b, 0x9c1fff0b, 0x68001ff6, 0x68001ff6},
+	{0x0000a578, 0x9c1fff0b, 0x9c1fff0b, 0x68001ff6, 0x68001ff6},
+	{0x0000a57c, 0x9c1fff0b, 0x9c1fff0b, 0x68001ff6, 0x68001ff6},
 	{0x0000a580, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a584, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a588, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -967,6 +968,7 @@ static const u32 ar9485_common_rx_gain_1_1[][2] = {
 	{0x00009e00, 0x03721b20},
 	{0x00009e04, 0x00082020},
 	{0x00009e18, 0x0300501e},
+	{0x00009e20, 0x000003ba},
 	{0x00009e2c, 0x00002e21},
 	{0x00009e44, 0x02182324},
 	{0x0000a000, 0x00060005},
@@ -1145,7 +1147,6 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec80d2e, 0x7ec80d2e},
 	{0x00009e14, 0x31395d53, 0x31396053, 0x312e6053, 0x312e5d53},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946222, 0xcf946222},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302010, 0x50302010},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -1164,7 +1165,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x000002a0, 0x000002a0},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 9fd46a4..beba14f 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -184,20 +184,22 @@ d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_2p1_modes_fast_clock
 dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9462_2p1_baseband_core_txfir_coeff_japan_2484
 c8dc777b012068116cd5282aade8eb460f397d20        ar9485_1_1_mac_postamble
 5d20e4848b97566ad55e0e95458463d622ee5480        ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1
-d9a90632a00a7b417154173b947dfffdeab23e51        ar9485Common_wo_xlna_rx_gain_1_1
-88b0666758b93ccaa26d500f4a80fec368c6a4e2        ar9485Modes_high_power_tx_gain_1_1
-0ac7092cc0a74e2cd03a3cc8821d46fbc3d1b3f4        ar9485Modes_high_ob_db_tx_gain_1_1
+118caf7bf15a5e2815e901201660790d687b8e88        ar9485Common_wo_xlna_rx_gain_1_1
+4ab61ebe1630e1e520bd42eae923f01b29595097        ar9485Modes_high_power_tx_gain_1_1
+847e6743c552579a318d5e6e8bae695836332be8        ar9485Modes_green_ob_db_tx_gain_1_1
+a86889c4252ea3089ed0dc763e5f831941fc4fcc        ar9485Modes_high_ob_db_tx_gain_1_1
 88b0666758b93ccaa26d500f4a80fec368c6a4e2        ar9485Modes_low_ob_db_tx_gain_1_1
 88b0666758b93ccaa26d500f4a80fec368c6a4e2        ar9485_modes_lowest_ob_db_tx_gain_1_1
+01f3b7a52af2ae57b0dd6e86435f7fbfdb37ccd4        ar9485Modes_green_spur_ob_db_tx_gain_1_1
 5ca2c72bdaf75ac11c0f8ae8dae5bef32ffa3c3b        ar9485_1_1
 26e183ba89fcd047fa2c6e92549ed33772800bfb        ar9485_1_1_radio_core
 2cb731330486f7c5bc501693eb729531124d21a4        ar9485_1_1_baseband_core
-1d9e632b3fdcb2db52f95dd75ff2eac31fcac0d6        ar9485_common_rx_gain_1_1
+7479ef6332b0d923e8e7ddb888eb3a09aac7a8b4        ar9485_common_rx_gain_1_1
 13bec2462d608918bcc8a5d2600c750730663745        ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1
 b8bc19098aa0ac38cf74ca4747e28ce6bad14fa1        ar9485_1_1_pcie_phy_clkreq_enable_L1
 7e1adfdb0f6a6dbbbe901d8eb019a425edfa58a6        ar9485_1_1_soc_preamble
 f247bc63c9a632092b94d1af1526650753b77a60        ar9485_fast_clock_1_1_baseband_postamble
-f1b452dfb558a755d9004241c29b43abd3332359        ar9485_1_1_baseband_postamble
+5e45cc3ca32a1cde2ad90f65bb81d0872b8dc87d        ar9485_1_1_baseband_postamble
 c8016c349304ed85842783f04f01f40a0cf4468f        ar9485_1_1_pcie_phy_clkreq_disable_L1
 f5bb0f6a25e512b85039e8c49ebc6555ff27ac4d        ar9485_1_1_radio_postamble
 be2a6982ce450a3e03b1593199395599778297b0        ar9485_1_1_mac_core
-- 
1.8.4

