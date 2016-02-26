Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60694 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbcBZIKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:10:40 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 06/13] ath9k: Update AR9485 initvals
Date: Fri, 26 Feb 2016 16:08:36 +0800
Message-Id: <1456474123-10520-7-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091043_302132_DE81705B)
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
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index ce83ce4..bdf6f10 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -1026,7 +1026,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x00009e10, 0x7ec88d2e, 0x7ec88d2e, 0x7ec80d2e, 0x7ec80d2e},
 	{0x00009e14, 0x31395d53, 0x31396053, 0x312e6053, 0x312e5d53},
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946222, 0xcf946222},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946220, 0xcf946220},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302010, 0x50302010},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
 	{0x0000a204, 0x01303fc0, 0x01303fc4, 0x01303fc4, 0x01303fc0},
@@ -1044,7 +1044,7 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x000002a0, 0x000002a0},
 	{0x0000a288, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a28c, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071982, 0x00071982},
 	{0x0000a2d8, 0xf999a83a, 0xf999a83a, 0xf999a83a, 0xf999a83a},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.9.1

