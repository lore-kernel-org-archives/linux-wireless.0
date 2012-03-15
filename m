Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51407 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2COWy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 18:54:59 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Update rx gain initval to improve rx sensitivity
Date: Fri, 16 Mar 2012 04:25:30 +0530
Message-ID: <1331852130-5868-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120315_235504_179041_7E3811E7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 026f9de..00c7c3d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1079,11 +1079,11 @@ static const u32 ar9300Common_rx_gain_table_2p2[][2] = {
 	{0x0000a074, 0x00000000},
 	{0x0000a078, 0x00000000},
 	{0x0000a07c, 0x00000000},
-	{0x0000a080, 0x22222229},
-	{0x0000a084, 0x1d1d1d1d},
-	{0x0000a088, 0x1d1d1d1d},
-	{0x0000a08c, 0x1d1d1d1d},
-	{0x0000a090, 0x171d1d1d},
+	{0x0000a080, 0x1a1a1a1a},
+	{0x0000a084, 0x1a1a1a1a},
+	{0x0000a088, 0x1a1a1a1a},
+	{0x0000a08c, 0x1a1a1a1a},
+	{0x0000a090, 0x171a1a1a},
 	{0x0000a094, 0x11111717},
 	{0x0000a098, 0x00030311},
 	{0x0000a09c, 0x00000000},
-- 
1.7.9.4

