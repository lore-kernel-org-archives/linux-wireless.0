Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60744 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbcBZIKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:10:51 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 08/13] ath9k: Update AR9565 initvals
Date: Fri, 26 Feb 2016 16:08:38 +0800
Message-Id: <1456474123-10520-9-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091053_841709_159221E5)
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
 drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
index 10d4a6c..35c1bbb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
@@ -347,7 +347,7 @@ static const u32 ar9565_1p0_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003a4, 0x000003a4},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcf946220, 0xcf946220},
+	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcf946220, 0xcf946220},
 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
-- 
1.9.1

