Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60544 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbcBZIKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:10:16 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 01/13] ath9k: Update QCA953x initvals
Date: Fri, 26 Feb 2016 16:08:31 +0800
Message-Id: <1456474123-10520-2-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091021_252520_3897EA48)
In-Reply-To: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
References: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

commit 14c5932805eb ("ath9k: Update QCA953x initvals")
disabled HW peak detect calibartion on QCA953x 1.0, which
should also be applied on 2.0.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
index 6fc0d07..eb42fb2 100644
--- a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
@@ -923,7 +923,7 @@ static const u32 qca953x_2p0_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcfa10820, 0xcfa10820, 0xcf946222, 0xcf946222},
+	{0x00009e3c, 0xcfa10820, 0xcfa10820, 0xcf946220, 0xcf946220},
 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -943,7 +943,7 @@ static const u32 qca953x_2p0_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000010, 0x00000010},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
 	{0x0000a2cc, 0x18c50033, 0x18c43433, 0x18c41033, 0x18c44c33},
 	{0x0000a2d0, 0x00041982, 0x00041982, 0x00041982, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
-- 
1.9.1

