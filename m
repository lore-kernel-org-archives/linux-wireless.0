Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53421 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3J2GRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 02:17:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Remove unused AR9462 2.0 initvals
Date: Tue, 29 Oct 2013 11:42:47 +0530
Message-Id: <1383027167-11199-1-git-send-email-sujith@msujith.org> (sfid-20131029_071710_561950_91262D7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 092b9d4..5a10dcf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -33,13 +33,6 @@ static const u32 ar9462_modes_fast_clock_2p0[][3] = {
 	{0x0000a254, 0x00000898, 0x00001130},
 };
 
-static const u32 ar9462_pciephy_clkreq_enable_L1_2p0[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18253ede},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0003780c},
-};
-
 static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8011, 0xd00a800d},
@@ -366,13 +359,6 @@ static const u32 ar9462_pciephy_clkreq_disable_L1_2p0[][2] = {
 	{0x00018c08, 0x0003780c},
 };
 
-static const u32 ar9462_pciephy_pll_on_clkreq_disable_L1_2p0[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18212ede},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0003780c},
-};
-
 static const u32 ar9462_2p0_radio_postamble_sys2ant[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x000160ac, 0xa4646c08, 0xa4646c08, 0x24645808, 0x24645808},
-- 
1.8.4.1

