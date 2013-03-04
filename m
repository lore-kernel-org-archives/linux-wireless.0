Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39375 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3CDHO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 02:14:56 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] initvals: Update AR9462 initvals
Date: Mon,  4 Mar 2013 12:43:21 +0530
Message-Id: <1362381201-9704-2-git-send-email-sujith@msujith.org> (sfid-20130304_081458_838256_40A36A6D)
In-Reply-To: <1362381201-9704-1-git-send-email-sujith@msujith.org>
References: <1362381201-9704-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9462_2p0_initvals.h | 49 ++++++++++++++++++------------------
 tools/initvals/checksums.txt         | 14 +++++------
 2 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/tools/initvals/ar9462_2p0_initvals.h b/tools/initvals/ar9462_2p0_initvals.h
index ccc42a7..999ab08 100644
--- a/tools/initvals/ar9462_2p0_initvals.h
+++ b/tools/initvals/ar9462_2p0_initvals.h
@@ -37,28 +37,28 @@ static const u32 ar9462_pciephy_clkreq_enable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18253ede},
 	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0003580c},
+	{0x00018c08, 0x0003780c},
 };
 
 static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a800d},
 	{0x00009820, 0x206a022e, 0x206a022e, 0x206a012e, 0x206a01ae},
-	{0x00009824, 0x5ac640de, 0x5ac640d0, 0x5ac640d0, 0x63c640da},
+	{0x00009824, 0x63c640de, 0x5ac640d0, 0x5ac640d0, 0x63c640da},
 	{0x00009828, 0x0796be89, 0x0696b081, 0x0696b881, 0x09143e81},
 	{0x0000982c, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4, 0x05eea6d4},
 	{0x00009830, 0x0000059c, 0x0000059c, 0x0000119c, 0x0000119c},
 	{0x00009c00, 0x000000c4, 0x000000c4, 0x000000c4, 0x000000c4},
-	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a0},
+	{0x00009e00, 0x0372111a, 0x0372111a, 0x037216a0, 0x037216a2},
 	{0x00009e04, 0x001c2020, 0x001c2020, 0x001c2020, 0x001c2020},
 	{0x00009e0c, 0x6c4000e2, 0x6d4000e2, 0x6d4000e2, 0x6c4000d8},
 	{0x00009e10, 0x92c88d2e, 0x7ec88d2e, 0x7ec84d2e, 0x7ec86d2e},
-	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3376605e, 0x32395d5e},
+	{0x00009e14, 0x37b95d5e, 0x37b9605e, 0x3236605e, 0x32365a5e},
 	{0x00009e18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcfd5c782, 0xcfd5c282},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -82,9 +82,9 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a3a4, 0x00000010, 0x00000010, 0x00000000, 0x00000000},
+	{0x0000a3a4, 0x00000050, 0x00000050, 0x00000000, 0x00000000},
 	{0x0000a3a8, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa, 0xaaaaaaaa},
-	{0x0000a3ac, 0xaaaaaa00, 0xaaaaaa30, 0xaaaaaa00, 0xaaaaaa00},
+	{0x0000a3ac, 0xaaaaaa00, 0xaa30aa30, 0xaaaaaa00, 0xaaaaaa00},
 	{0x0000a41c, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce},
 	{0x0000a420, 0x000001ce, 0x000001ce, 0x000001ce, 0x000001ce},
 	{0x0000a424, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce, 0x1ce739ce},
@@ -363,14 +363,14 @@ static const u32 ar9462_pciephy_clkreq_disable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18213ede},
 	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0003580c},
+	{0x00018c08, 0x0003780c},
 };
 
 static const u32 ar9462_pciephy_pll_on_clkreq_disable_L1_2p0[][2] = {
 	/* Addr      allmodes  */
 	{0x00018c00, 0x18212ede},
 	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0003580c},
+	{0x00018c08, 0x0003780c},
 };
 
 static const u32 ar9462_2p0_radio_postamble_sys2ant[][5] = {
@@ -775,7 +775,7 @@ static const u32 ar9462_2p0_baseband_core[][2] = {
 	{0x00009fc0, 0x803e4788},
 	{0x00009fc4, 0x0001efb5},
 	{0x00009fcc, 0x40000014},
-	{0x00009fd0, 0x01193b93},
+	{0x00009fd0, 0x0a193b93},
 	{0x0000a20c, 0x00000000},
 	{0x0000a220, 0x00000000},
 	{0x0000a224, 0x00000000},
@@ -850,7 +850,7 @@ static const u32 ar9462_2p0_baseband_core[][2] = {
 	{0x0000a7cc, 0x00000000},
 	{0x0000a7d0, 0x00000000},
 	{0x0000a7d4, 0x00000004},
-	{0x0000a7dc, 0x00000001},
+	{0x0000a7dc, 0x00000000},
 	{0x0000a7f0, 0x80000000},
 	{0x0000a8d0, 0x004b6a8e},
 	{0x0000a8d4, 0x00000820},
@@ -886,7 +886,7 @@ static const u32 ar9462_modes_high_ob_db_tx_gain_table_2p0[][5] = {
 	{0x0000a2e0, 0x0000f000, 0x0000f000, 0x03ccc584, 0x03ccc584},
 	{0x0000a2e4, 0x01ff0000, 0x01ff0000, 0x03f0f800, 0x03f0f800},
 	{0x0000a2e8, 0x00000000, 0x00000000, 0x03ff0000, 0x03ff0000},
-	{0x0000a410, 0x000050d9, 0x000050d9, 0x000050d9, 0x000050d9},
+	{0x0000a410, 0x000050da, 0x000050da, 0x000050de, 0x000050de},
 	{0x0000a458, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a500, 0x00002220, 0x00002220, 0x00000000, 0x00000000},
 	{0x0000a504, 0x06002223, 0x06002223, 0x04000002, 0x04000002},
@@ -906,20 +906,20 @@ static const u32 ar9462_modes_high_ob_db_tx_gain_table_2p0[][5] = {
 	{0x0000a53c, 0x41025e4a, 0x41025e4a, 0x34001640, 0x34001640},
 	{0x0000a540, 0x48025e6c, 0x48025e6c, 0x38001660, 0x38001660},
 	{0x0000a544, 0x4e025e8e, 0x4e025e8e, 0x3b001861, 0x3b001861},
-	{0x0000a548, 0x53025eb2, 0x53025eb2, 0x3e001a81, 0x3e001a81},
-	{0x0000a54c, 0x59025eb6, 0x59025eb6, 0x42001a83, 0x42001a83},
-	{0x0000a550, 0x5d025ef6, 0x5d025ef6, 0x44001c84, 0x44001c84},
+	{0x0000a548, 0x55025eb3, 0x55025eb3, 0x3e001a81, 0x3e001a81},
+	{0x0000a54c, 0x58025ef3, 0x58025ef3, 0x42001a83, 0x42001a83},
+	{0x0000a550, 0x5d025ef6, 0x5d025ef6, 0x44001a84, 0x44001a84},
 	{0x0000a554, 0x62025f56, 0x62025f56, 0x48001ce3, 0x48001ce3},
 	{0x0000a558, 0x66027f56, 0x66027f56, 0x4c001ce5, 0x4c001ce5},
 	{0x0000a55c, 0x6a029f56, 0x6a029f56, 0x50001ce9, 0x50001ce9},
 	{0x0000a560, 0x70049f56, 0x70049f56, 0x54001ceb, 0x54001ceb},
-	{0x0000a564, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a568, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a56c, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a570, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a574, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a578, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
-	{0x0000a57c, 0x7504ff56, 0x7504ff56, 0x56001eec, 0x56001eec},
+	{0x0000a564, 0x751ffff6, 0x751ffff6, 0x56001eec, 0x56001eec},
+	{0x0000a568, 0x751ffff6, 0x751ffff6, 0x58001ef0, 0x58001ef0},
+	{0x0000a56c, 0x751ffff6, 0x751ffff6, 0x5a001ef4, 0x5a001ef4},
+	{0x0000a570, 0x751ffff6, 0x751ffff6, 0x5c001ff6, 0x5c001ff6},
+	{0x0000a574, 0x751ffff6, 0x751ffff6, 0x5c001ff6, 0x5c001ff6},
+	{0x0000a578, 0x751ffff6, 0x751ffff6, 0x5c001ff6, 0x5c001ff6},
+	{0x0000a57c, 0x751ffff6, 0x751ffff6, 0x5c001ff6, 0x5c001ff6},
 	{0x0000a600, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a604, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a608, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
@@ -1053,7 +1053,6 @@ static const u32 ar9462_2p0_mac_core[][2] = {
 	{0x00008044, 0x00000000},
 	{0x00008048, 0x00000000},
 	{0x0000804c, 0xffffffff},
-	{0x00008050, 0xffffffff},
 	{0x00008054, 0x00000000},
 	{0x00008058, 0x00000000},
 	{0x0000805c, 0x000fc78f},
@@ -1117,9 +1116,9 @@ static const u32 ar9462_2p0_mac_core[][2] = {
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
diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 896d8af..7aae7d4 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -138,22 +138,22 @@ ca6088034f339ea8f106f7f034d34baafec0c0ca        ar9340Modes_high_ob_db_tx_gain_t
 481b3066bd6b4dfa425027157f7c6252b535ebe4        ar9340Common_wo_xlna_rx_gain_table_1p0
 1b9f617ab8c10ec0760e81fe61d469692f2acc29        ar9340_1p0_soc_preamble
 d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_modes_fast_clock_2p0
-8bf1688079add33889085f3d35a5fab61c33487f        ar9462_pciephy_clkreq_enable_L1_2p0
-8dacf543535b605143b40aef74f7d46af064cb43        ar9462_2p0_baseband_postamble
+222ed8213d3ffb0d12cf4c7019bdfd874e45c7d7        ar9462_pciephy_clkreq_enable_L1_2p0
+efb4c74c657dbc49ab80dd1d42a5b8e6ff0c3651        ar9462_2p0_baseband_postamble
 d0f7aff1a1ab7e6f6bbda0da067714459341ce5f        ar9462_common_rx_gain_table_2p0
-bc232a96b4c1530bebe654420652a9f080a09db8        ar9462_pciephy_clkreq_disable_L1_2p0
-f4c2241d40995e09f8736ed2ef5eaa5d6f051aa5        ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
+2fbe90336971cd66f0264c0cc57605c2de069d5f        ar9462_pciephy_clkreq_disable_L1_2p0
+a3173672141a2ac797e660228d41a609f9ab2c4c        ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
 057d1ee3d10321f1cc4d6c19cf1927e2ae56af28        ar9462_2p0_radio_postamble_sys2ant
 481b3066bd6b4dfa425027157f7c6252b535ebe4        ar9462_common_wo_xlna_rx_gain_table_2p0
 dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9462_2p0_baseband_core_txfir_coeff_japan_2484
 a36b90fcdeeb4071fd090537f008f8091d885581        ar9462_modes_low_ob_db_tx_gain_table_2p0
 7c0a54aaf0f77f5bf048126e43feea746732d43f        ar9462_2p0_soc_postamble
-e87864956a7209224880cff035b4441b0ab3fbcc        ar9462_2p0_baseband_core
+53d41e2eb8eadab02e1b615f4f596a55cf2a8905        ar9462_2p0_baseband_core
 b50d2fe654b069110bdbe06e5065f2aa9b117e3e        ar9462_2p0_radio_postamble
-5a98e71e601539bf31af7b9d18b210ab70f99dae        ar9462_modes_high_ob_db_tx_gain_table_2p0
+068b0f30229b9cbf385a49303d29b8fb979f25b3        ar9462_modes_high_ob_db_tx_gain_table_2p0
 fd98d0361e085b102131c2dc07c601e0a7ccdd13        ar9462_2p0_radio_core
 3e60b14761abfa24d758727954d1d5cc398abf7f        ar9462_2p0_soc_preamble
-fc8623151293cc7739d0fb8e2873256749c74930        ar9462_2p0_mac_core
+2e6ddfe3c7e291ca6bebb5791d8a73c492db0399        ar9462_2p0_mac_core
 c8dc777b012068116cd5282aade8eb460f397d20        ar9462_2p0_mac_postamble
 72675fd0f308e6f31502e283119e12469d262f40        ar9462_common_mixed_rx_gain_table_2p0
 c8dc777b012068116cd5282aade8eb460f397d20        ar9485_1_1_mac_postamble
-- 
1.8.1.5

