Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4519 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbbHLGUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 02:20:55 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH] ath9k: add correct MAC/BB name for ar9561
Date: Wed, 12 Aug 2015 14:20:46 +0800
Message-ID: <1439360446-31422-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150812_082104_980228_859E9EDC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

MAC/BB name is"????" if the MAC/BB is unknown.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a31a680..1dd0339 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3186,6 +3186,7 @@ static struct {
 	{ AR_SREV_VERSION_9550,         "9550" },
 	{ AR_SREV_VERSION_9565,         "9565" },
 	{ AR_SREV_VERSION_9531,         "9531" },
+	{ AR_SREV_VERSION_9561,         "9561" },
 };
 
 /* For devices with external radios */
-- 
1.9.1

