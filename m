Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34024 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1LSVZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:19 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 06/15] initvals: add checksums for ar9580
Date: Mon, 19 Dec 2011 22:24:51 +0100
Message-Id: <1324329900-3923-7-git-send-email-juhosg@openwrt.org> (sfid-20111219_222533_092841_58BCDF1F)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 checksums.txt |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/checksums.txt b/checksums.txt
index c85a280..a2e19ec 100644
--- a/checksums.txt
+++ b/checksums.txt
@@ -143,3 +143,23 @@
 0x00000000296bb64e        ar9485_1_0_pcie_phy_clkreq_disable_L1
 0x00000000f6bce907        ar9485_1_0_radio_postamble
 0x00000000d9748978        ar9485_1_0_mac_core
+0x00000000e912711f        ar9580_1p0_modes_fast_clock
+0x000000004a488fc7        ar9580_1p0_radio_postamble
+0x00000000f3888b02        ar9580_1p0_baseband_core
+0x0000000003f783bb        ar9580_1p0_mac_postamble
+0x0000000094be244a        ar9580_1p0_low_ob_db_tx_gain_table
+0x0000000094be244a        ar9580_1p0_high_power_tx_gain_table
+0x0000000090be244a        ar9580_1p0_lowest_ob_db_tx_gain_table
+0x00000000ed9eaac6        ar9580_1p0_baseband_core_txfir_coeff_japan_2484
+0x00000000c4d66d1b        ar9580_1p0_mac_core
+0x00000000e8e9043a        ar9580_1p0_mixed_ob_db_tx_gain_table
+0x000000003521a300        ar9580_1p0_wo_xlna_rx_gain_table
+0x00000000301fc841        ar9580_1p0_soc_postamble
+0x00000000a9a06b3a        ar9580_1p0_high_ob_db_tx_gain_table
+0x00000000a15ccf1b        ar9580_1p0_soc_preamble
+0x0000000029495000        ar9580_1p0_rx_gain_table
+0x0000000037ac0ee8        ar9580_1p0_radio_core
+0x00000000603a1b80        ar9580_1p0_baseband_postamble
+0x000000003d8b4396        ar9580_1p0_pcie_phy_clkreq_enable_L1
+0x00000000398b4396        ar9580_1p0_pcie_phy_clkreq_disable_L1
+0x00000000397b4396        ar9580_1p0_pcie_phy_pll_on_clkreq
-- 
1.7.2.1

