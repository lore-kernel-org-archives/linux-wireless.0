Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37196 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946393Ab2LFSRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:31 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 01/13] qca-swiss-army-knife: refresh checksums.txt
Date: Thu,  6 Dec 2012 19:17:15 +0100
Message-Id: <1354817847-23440-2-git-send-email-juhosg@openwrt.org> (sfid-20121206_191743_314596_B29B34F1)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initvals of the AR9462 and AR9485 chips
has been updated recently, but checksums.txt
does not reflects that. Refresh it in order to
contain the actual sha1sum values.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/checksums.txt |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 9a9f909..9407ae4 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -139,23 +139,24 @@ ca6088034f339ea8f106f7f034d34baafec0c0ca        ar9340Modes_high_ob_db_tx_gain_t
 1b9f617ab8c10ec0760e81fe61d469692f2acc29        ar9340_1p0_soc_preamble
 c8dc777b012068116cd5282aade8eb460f397d20        ar9485_1_1_mac_postamble
 5d20e4848b97566ad55e0e95458463d622ee5480        ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1
-9c6add06664b36a13b93a3f6406ab35d24979045        ar9485Common_wo_xlna_rx_gain_1_1
-092ac2598c26b798386c3fd64920d765f8e17c55        ar9485Modes_high_power_tx_gain_1_1
-092ac2598c26b798386c3fd64920d765f8e17c55        ar9485Modes_high_ob_db_tx_gain_1_1
-092ac2598c26b798386c3fd64920d765f8e17c55        ar9485Modes_low_ob_db_tx_gain_1_1
-092ac2598c26b798386c3fd64920d765f8e17c55        ar9485_modes_lowest_ob_db_tx_gain_1_1
-8b9dc388f684bcfd25c4aea47d34c617798ae104        ar9485_1_1
+d9a90632a00a7b417154173b947dfffdeab23e51        ar9485Common_wo_xlna_rx_gain_1_1
+88b0666758b93ccaa26d500f4a80fec368c6a4e2        ar9485Modes_high_power_tx_gain_1_1
+0ac7092cc0a74e2cd03a3cc8821d46fbc3d1b3f4        ar9485Modes_high_ob_db_tx_gain_1_1
+88b0666758b93ccaa26d500f4a80fec368c6a4e2        ar9485Modes_low_ob_db_tx_gain_1_1
+88b0666758b93ccaa26d500f4a80fec368c6a4e2        ar9485_modes_lowest_ob_db_tx_gain_1_1
+5ca2c72bdaf75ac11c0f8ae8dae5bef32ffa3c3b        ar9485_1_1
 26e183ba89fcd047fa2c6e92549ed33772800bfb        ar9485_1_1_radio_core
-0e35263848420cd394a19288ecdcc8bf6037d09e        ar9485_1_1_baseband_core
-7d3b6958741de3fd02a55da56292f0e36c7bb0f9        ar9485_common_rx_gain_1_1
+2cb731330486f7c5bc501693eb729531124d21a4        ar9485_1_1_baseband_core
+1d9e632b3fdcb2db52f95dd75ff2eac31fcac0d6        ar9485_common_rx_gain_1_1
 13bec2462d608918bcc8a5d2600c750730663745        ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1
 b8bc19098aa0ac38cf74ca4747e28ce6bad14fa1        ar9485_1_1_pcie_phy_clkreq_enable_L1
 7e1adfdb0f6a6dbbbe901d8eb019a425edfa58a6        ar9485_1_1_soc_preamble
 f247bc63c9a632092b94d1af1526650753b77a60        ar9485_fast_clock_1_1_baseband_postamble
-94ad30af190524bf203b9455888503207ae6200b        ar9485_1_1_baseband_postamble
+f1b452dfb558a755d9004241c29b43abd3332359        ar9485_1_1_baseband_postamble
 c8016c349304ed85842783f04f01f40a0cf4468f        ar9485_1_1_pcie_phy_clkreq_disable_L1
 f5bb0f6a25e512b85039e8c49ebc6555ff27ac4d        ar9485_1_1_radio_postamble
 be2a6982ce450a3e03b1593199395599778297b0        ar9485_1_1_mac_core
+dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9485_1_1_baseband_core_txfir_coeff_japan_2484
 87e0ecae5df96673e22bc448b17d813510964de8        ar9580_1p0_modes_fast_clock
 6b0fb5b3698c99f42a885c8e982ae436363f1865        ar9580_1p0_radio_postamble
 5b81bf27a30c826cfde3e8f6746473e949cb41ef        ar9580_1p0_baseband_core
@@ -178,7 +179,7 @@ d0865f0cebcd7df2114a5626a3d0d19b8dae5710        ar9580_1p0_pcie_phy_clkreq_disab
 45047f648d4c6138429f8bbc97680ac07f74ba62        ar9580_1p0_pcie_phy_pll_on_clkreq
 d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_modes_fast_clock_2p0
 8bf1688079add33889085f3d35a5fab61c33487f        ar9462_pciephy_clkreq_enable_L1_2p0
-96d7f2eafc15577fb6a5a907622198e258406b19        ar9462_2p0_baseband_postamble
+8dacf543535b605143b40aef74f7d46af064cb43        ar9462_2p0_baseband_postamble
 d0f7aff1a1ab7e6f6bbda0da067714459341ce5f        ar9462_common_rx_gain_table_2p0
 bc232a96b4c1530bebe654420652a9f080a09db8        ar9462_pciephy_clkreq_disable_L1_2p0
 f4c2241d40995e09f8736ed2ef5eaa5d6f051aa5        ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
-- 
1.7.10

