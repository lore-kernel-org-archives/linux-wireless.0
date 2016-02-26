Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60606 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbcBZIK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:10:26 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 03/13] ath9k: Update AR933x initvals
Date: Fri, 26 Feb 2016 16:08:33 +0800
Message-Id: <1456474123-10520-4-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091028_660048_10D00003)
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
 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h | 4 ++--
 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h b/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
index 2c42ff0..29479af 100644
--- a/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
@@ -40,7 +40,7 @@ static const u32 ar9331_1p1_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00003221, 0x00003221},
-	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946222, 0xcf946222},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946220, 0xcf946220},
 	{0x00009e44, 0x02321e27, 0x02321e27, 0x02282324, 0x02282324},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302010, 0x50302010},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -59,7 +59,7 @@ static const u32 ar9331_1p1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071982, 0x00071982, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
index 2154efc..c4a6ffa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
@@ -345,7 +345,7 @@ static const u32 ar9331_1p2_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00003221, 0x00003221},
-	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946222, 0xcf946222},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946220, 0xcf946220},
 	{0x00009e44, 0x02321e27, 0x02321e27, 0x02282324, 0x02282324},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302010, 0x50302010},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -364,7 +364,7 @@ static const u32 ar9331_1p2_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071981, 0x00071981},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.9.1

