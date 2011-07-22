Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1GVFnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 24/31] ath6kl: Rearrange the variable and the value position in IF condition
Date: Fri, 22 Jul 2011 08:41:57 +0300
Message-ID: <1311313324-6766-26-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074345_976275_F7F5A726)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 9d9948e..5580e22 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1229,7 +1229,7 @@ static void htc_proc_cred_rpt(struct htc_target *target,
 			endpoint->ep_st.cred_rpt_from_other += 1;
 		}
 
-		if (ENDPOINT_0 == rpt->eid)
+		if (rpt->eid == ENDPOINT_0)
 			/* always give endpoint 0 credits back */
 			endpoint->cred_dist.credits += rpt->credits;
 		else {
-- 
1.7.1

