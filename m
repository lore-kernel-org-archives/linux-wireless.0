Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65068 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab1I3Nsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 09:48:45 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/5] ath6kl: Fix sparse warning "symbol 'conn' shadows an earlier one"
Date: Fri, 30 Sep 2011 19:18:42 +0530
Message-ID: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110930_154849_260082_B84CA857)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index a711707..bcf7b01 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1235,7 +1235,6 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 			 * frame to it on the air else send the
 			 * frame up the stack.
 			 */
-			struct ath6kl_sta *conn = NULL;
 			conn = ath6kl_find_sta(ar, datap->h_dest);
 
 			if (conn && ar->intra_bss) {
-- 
1.7.0.4

