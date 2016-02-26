Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60674 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbcBZIKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:10:36 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 05/13] ath9k: Update AR9462 initvals
Date: Fri, 26 Feb 2016 16:08:35 +0800
Message-Id: <1456474123-10520-6-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091038_547621_DFCE4DFB)
In-Reply-To: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
References: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

HW peak detect calibration would fail for AR9300 chips and
we went for implementing the SW way of doing it instead of
HW doing the peak detect calibration.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 4 ++--
 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 1b6b4d0..b00dd64 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -59,7 +59,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c780, 0xcfd5c280},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -79,7 +79,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
index dc3adda..0f8745e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
@@ -239,7 +239,7 @@ static const u32 ar9462_2p1_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003a5, 0x000003a5, 0x000003a5, 0x000003a5},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c780, 0xcfd5c280},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -259,7 +259,7 @@ static const u32 ar9462_2p1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.9.1

