Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34012 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab1LSVZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:17 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 05/15] initvals: add checksums for AR9330 1.[12]
Date: Mon, 19 Dec 2011 22:24:50 +0100
Message-Id: <1324329900-3923-6-git-send-email-juhosg@openwrt.org> (sfid-20111219_222547_918597_84C7B23E)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 checksums.txt |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/checksums.txt b/checksums.txt
index 8fc8fd0..c85a280 100644
--- a/checksums.txt
+++ b/checksums.txt
@@ -88,6 +88,41 @@
 0x0000000029734396        ar9300PciePhy_pll_on_clkreq_disable_L1_2p2
 0x000000002d834396        ar9300PciePhy_clkreq_enable_L1_2p2
 0x0000000029834396        ar9300PciePhy_clkreq_disable_L1_2p2
+0x00000000f92a5e5c        ar9331_1p1_baseband_postamble
+0x0000000060d0a442        ar9331_modes_lowest_ob_db_tx_gain_1p1
+0x000000002eafd425        ar9331_modes_high_ob_db_tx_gain_1p1
+0x0000000060d0a442        ar9331_modes_low_ob_db_tx_gain_1p1
+0x00000000ed9eaac6        ar9331_1p1_baseband_core_txfir_coeff_japan_2484
+0x0000000043a7b840        ar9331_1p1_xtal_25M
+0x0000000070d13603        ar9331_1p1_radio_core
+0x000000003118c942        ar9331_1p1_soc_postamble
+0x00000000bace1580        ar9331_common_wo_xlna_rx_gain_1p1
+0x0000000012057ba7        ar9331_1p1_baseband_core
+0x0000000060d0a442        ar9331_modes_high_power_tx_gain_1p1
+0x0000000003f783bb        ar9331_1p1_mac_postamble
+0x000000000041b68e        ar9331_1p1_soc_preamble
+0x000000003bd50340        ar9331_1p1_xtal_40M
+0x000000002ec9e6f3        ar9331_1p1_mac_core
+0x00000000adbe1180        ar9331_common_rx_gain_1p1
+0x0000000000000207        ar9331_common_tx_gain_offset1_1
+0x000000000005de09        ar9331_1p1_chansel_xtal_25M
+0x0000000000062522        ar9331_1p1_chansel_xtal_40M
+0x000000006fd38378        ar9331_modes_lowest_ob_db_tx_gain_1p2
+0x00000000f92a5e5c        ar9331_1p2_baseband_postamble
+0x000000006fd38378        ar9331_modes_high_ob_db_tx_gain_1p2
+0x000000006fd38378        ar9331_modes_low_ob_db_tx_gain_1p2
+0x00000000ed9eaac6        ar9331_1p2_baseband_core_txfir_coeff_japan_2484
+0x0000000043a7b840        ar9331_1p2_xtal_25M
+0x000000007c213603        ar9331_1p2_radio_core
+0x000000003118c942        ar9331_1p2_soc_postamble
+0x00000000bace1580        ar9331_common_wo_xlna_rx_gain_1p2
+0x0000000012057ba7        ar9331_1p2_baseband_core
+0x000000006fd38378        ar9331_modes_high_power_tx_gain_1p2
+0x0000000003f783bb        ar9331_1p2_mac_postamble
+0x000000000041b68e        ar9331_1p2_soc_preamble
+0x000000003bd50340        ar9331_1p2_xtal_40M
+0x000000002ec9e6f3        ar9331_1p2_mac_core
+0x0000000087da7380        ar9331_common_rx_gain_1p2
 0x0000000000266010        ar9485Common_1_0
 0x0000000003f783bb        ar9485_1_0_mac_postamble
 0x00000000299bb64e        ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1
-- 
1.7.2.1

