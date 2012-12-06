Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37220 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab2LFSRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:36 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 12/13] qca-swiss-army-knife: add checksums for AR955X initvals
Date: Thu,  6 Dec 2012 19:17:26 +0100
Message-Id: <1354817847-23440-13-git-send-email-juhosg@openwrt.org> (sfid-20121206_191748_134268_4CF3C1C4)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that initvals supports the AR955X family,
refresh 'checksums.txt'.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/checksums.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index f02df5b..0128621 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -176,6 +176,22 @@ c8016c349304ed85842783f04f01f40a0cf4468f        ar9485_1_1_pcie_phy_clkreq_disab
 f5bb0f6a25e512b85039e8c49ebc6555ff27ac4d        ar9485_1_1_radio_postamble
 be2a6982ce450a3e03b1593199395599778297b0        ar9485_1_1_mac_core
 dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9485_1_1_baseband_core_txfir_coeff_japan_2484
+8ac169541145c0815a3310fe70ecb18d0b5beb1e        ar955x_1p0_radio_postamble
+dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar955x_1p0_baseband_core_txfir_coeff_japan_2484
+79c5a0883ca14e2cd93b00c06956686d6afc35b8        ar955x_1p0_baseband_postamble
+944fce08afd997013da4a0f2fc49f04b215a19d7        ar955x_1p0_radio_core
+a9ee65d54600d6a4fc4e81292083b7673161a1f7        ar955x_1p0_modes_xpa_tx_gain_table
+c034452a6673a30a02a02510aefd48274bb9ab42        ar955x_1p0_mac_core
+2b67b93c41a4e7cd5761a7c698387f4282d3d092        ar955x_1p0_common_rx_gain_table
+6d91c355cd39873388ba87c71a92fbdfcf200491        ar955x_1p0_baseband_core
+481b3066bd6b4dfa425027157f7c6252b535ebe4        ar955x_1p0_common_wo_xlna_rx_gain_table
+cb21861cd9f3fa38eccd2552495820f64e1402d1        ar955x_1p0_soc_preamble
+894acf855e7b814678270fcf5c8736b5035755b9        ar955x_1p0_common_wo_xlna_rx_gain_bounds
+c8dc777b012068116cd5282aade8eb460f397d20        ar955x_1p0_mac_postamble
+91301f020ec21e066b43364b0f21bb810b0fe90c        ar955x_1p0_common_rx_gain_bounds
+b836a622916e66da6a23c9cd34a7d933571ff6db        ar955x_1p0_modes_no_xpa_tx_gain_table
+8ad6e285ff8db78d133b0b5203145ef2c7f97364        ar955x_1p0_soc_postamble
+87e0ecae5df96673e22bc448b17d813510964de8        ar955x_1p0_modes_fast_clock
 839b2486a70775db100fca6421860d4922fbf945        ar9565_1p0_mac_core
 c8dc777b012068116cd5282aade8eb460f397d20        ar9565_1p0_mac_postamble
 be2a958615907b5f7766336b124d79cb3dbb3c1f        ar9565_1p0_baseband_core
-- 
1.7.10

