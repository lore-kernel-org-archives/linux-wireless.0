Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26300 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRNcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 09:32:05 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k_hw: update ar9462 dac_async_fifo initval
Date: Mon, 18 Jun 2012 19:02:39 +0530
Message-ID: <1340026360-18873-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120618_153209_380304_E4B549B8)
In-Reply-To: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
index 8f406ff..bbf48918a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
@@ -61,7 +61,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
-	{0x0000a204, 0x013187c0, 0x013187c4, 0x013187c4, 0x013187c0},
+	{0x0000a204, 0x01318fc0, 0x01318fc4, 0x01318fc4, 0x01318fc0},
 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
 	{0x0000a22c, 0x01026a2f, 0x01026a27, 0x01026a2f, 0x01026a2f},
 	{0x0000a230, 0x0000400a, 0x00004014, 0x00004016, 0x0000400b},
-- 
1.7.10.4

