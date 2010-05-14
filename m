Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59786 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0ENFsc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 01:48:32 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 22:48:32 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19436.58443.382954.146552@gargle.gargle.HOWL>
Date: Fri, 14 May 2010 11:18:59 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath9k_htc: Increase credit size
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the maximum supported by the firmware.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 064397f..2173196 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -159,7 +159,7 @@ static int htc_config_pipe_credits(struct htc_target *target)
 
 	cp_msg->message_id = cpu_to_be16(HTC_MSG_CONFIG_PIPE_ID);
 	cp_msg->pipe_id = USB_WLAN_TX_PIPE;
-	cp_msg->credits = 28;
+	cp_msg->credits = 33;
 
 	target->htc_flags |= HTC_OP_CONFIG_PIPE_CREDITS;
 
-- 
1.7.1

