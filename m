Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50820 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0LLNer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 08:34:47 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 6/7] ath9k_hw: update AR9003 initvals for improved radar detection
Date: Sun, 12 Dec 2010 14:34:36 +0100
Message-Id: <1292160877-50618-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292160877-50618-5-git-send-email-nbd@openwrt.org>
References: <1292160877-50618-1-git-send-email-nbd@openwrt.org>
 <1292160877-50618-2-git-send-email-nbd@openwrt.org>
 <1292160877-50618-3-git-send-email-nbd@openwrt.org>
 <1292160877-50618-4-git-send-email-nbd@openwrt.org>
 <1292160877-50618-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduces the likelihood of false pulse detects in the hardware

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index a14a5e4..ec50ca1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -638,6 +638,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
 	{0x0000a204, 0x000037c0, 0x000037c4, 0x000037c4, 0x000037c0},
 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
+	{0x0000a22c, 0x01026a2f, 0x01026a2f, 0x01026a2f, 0x01026a2f},
 	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
 	{0x0000a234, 0x00000fff, 0x10000fff, 0x10000fff, 0x00000fff},
 	{0x0000a238, 0xffb81018, 0xffb81018, 0xffb81018, 0xffb81018},
@@ -680,7 +681,7 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x0000981c, 0x00020028},
 	{0x00009834, 0x6400a290},
 	{0x00009838, 0x0108ecff},
-	{0x0000983c, 0x14750600},
+	{0x0000983c, 0x0d000600},
 	{0x00009880, 0x201fff00},
 	{0x00009884, 0x00001042},
 	{0x000098a4, 0x00200400},
@@ -722,7 +723,6 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x0000a220, 0x00000000},
 	{0x0000a224, 0x00000000},
 	{0x0000a228, 0x10002310},
-	{0x0000a22c, 0x01036a27},
 	{0x0000a23c, 0x00000000},
 	{0x0000a244, 0x0c000000},
 	{0x0000a2a0, 0x00000001},
-- 
1.7.3.2

