Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:32955 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab2LMSmF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:42:05 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] qca-swiss-army-knife: update checksums.txt
Date: Thu, 13 Dec 2012 19:41:47 +0100
Message-Id: <1355424107-31412-1-git-send-email-juhosg@openwrt.org> (sfid-20121213_194208_687079_C2BF744C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the recent changes in AR9340 initvals,
checksums.txt needs to be updated.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/checksums.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 0128621..837b0c8 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -123,7 +123,7 @@ b7bd4501d52be3219578b47403dc7cde8178d2f9        ar9331_1p2_mac_core
 d54185c6c9486055563fd86d0a1f536e6ab81745        ar9340Modes_lowest_ob_db_tx_gain_table_1p0
 87e0ecae5df96673e22bc448b17d813510964de8        ar9340Modes_fast_clock_1p0
 58815c0dcf227e155a4dee6a5c69843e1ca4707d        ar9340_1p0_radio_core
-7939d402295e3d37914f1bcc70f10d9d15696f58        ar9340_1p0_radio_core_40M
+fc8b1321c600afd10ff73140efe4230e2121b395        ar9340_1p0_radio_core_40M
 c8dc777b012068116cd5282aade8eb460f397d20        ar9340_1p0_mac_postamble
 8ad6e285ff8db78d133b0b5203145ef2c7f97364        ar9340_1p0_soc_postamble
 ad869d094ffe9893209e8961197f00d560c74551        ar9340_1p0_baseband_postamble
@@ -134,7 +134,7 @@ ca6088034f339ea8f106f7f034d34baafec0c0ca        ar9340Modes_high_ob_db_tx_gain_t
 2b67b93c41a4e7cd5761a7c698387f4282d3d092        ar9340Common_rx_gain_table_1p0
 8ee20f85d01d7fe5fac96077d1dc30878aa8966e        ar9340Modes_low_ob_db_tx_gain_table_1p0
 39b2d884643923daceb1273b8f7826348c216277        ar9340Modes_mixed_ob_db_tx_gain_table_1p0
-58caac4e0a0184f6904d4adc7f7be8e528e6d0e3        ar9340_1p0_mac_core
+8023e4790d8b4e99c93dfee8d1afa66ef5ae496a        ar9340_1p0_mac_core
 481b3066bd6b4dfa425027157f7c6252b535ebe4        ar9340Common_wo_xlna_rx_gain_table_1p0
 1b9f617ab8c10ec0760e81fe61d469692f2acc29        ar9340_1p0_soc_preamble
 d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_modes_fast_clock_2p0
-- 
1.7.10

