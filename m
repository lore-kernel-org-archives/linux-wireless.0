Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:62326 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaFXLg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 07:36:59 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/5] ath9k_hw: update CCK loop coefficients for AR953x 1.0
Date: Tue, 24 Jun 2014 17:07:45 +0530
Message-ID: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140624_133702_476431_DA378771)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
index 8e5c3b9..1907f86 100644
--- a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
@@ -219,7 +219,7 @@ static const u32 qca953x_1p0_baseband_core[][2] = {
 	{0x00009d04, 0x40206c10},
 	{0x00009d08, 0x009c4060},
 	{0x00009d0c, 0x9883800a},
-	{0x00009d10, 0x01884061},
+	{0x00009d10, 0x018848c6},
 	{0x00009d14, 0x00c0040b},
 	{0x00009d18, 0x00000000},
 	{0x00009e08, 0x0038230c},
-- 
2.0.0

