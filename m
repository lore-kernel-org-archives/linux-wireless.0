Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64133 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1G2MJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 08:09:35 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 11/13] ath9k_hw: Disable Walsh spatial spreading for 2 chains
Date: Fri, 29 Jul 2011 17:38:18 +0530
Message-ID: <1311941300-2590-11-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110729_140939_017055_504E420C)
In-Reply-To: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311941300-2590-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 2339728..28b44b0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -636,7 +636,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
 	{0x00009e44, 0x02321e27, 0x02321e27, 0x02291e27, 0x02291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
-	{0x0000a204, 0x000037c0, 0x000037c4, 0x000037c4, 0x000037c0},
+	{0x0000a204, 0x000036c0, 0x000036c4, 0x000036c4, 0x000036c0},
 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
 	{0x0000a22c, 0x01026a2f, 0x01026a2f, 0x01026a2f, 0x01026a2f},
 	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
-- 
1.7.6

