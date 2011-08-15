Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34013 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1HOIBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 04:01:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath6kl: fix indentation in htc_issued_send()
Date: Mon, 15 Aug 2011 01:04:03 -0700
Message-ID: <1313395443-5392-5-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110815_100157_922929_2987ACFE)
In-Reply-To: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1313395443-5392-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One line used space to indent. Oddly enough checkpatch didn't complain
about this.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index a8dc5c3..2001660 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -196,7 +196,7 @@ static int htc_issue_send(struct htc_target *target, struct htc_packet *packet)
 				 HIF_WR_SYNC_BLOCK_INC);
 
 		packet->status = status;
-		 packet->buf += HTC_HDR_LENGTH;
+		packet->buf += HTC_HDR_LENGTH;
 	} else
 		status = hif_write_async(target->dev->ar,
 				target->dev->ar->mbox_info.htc_addr,
-- 
1.7.1

