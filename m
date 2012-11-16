Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50681 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2KPMwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:52:12 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 2/8] ath6kl: Use standard way to assign the boolean variable
Date: Fri, 16 Nov 2012 18:22:03 +0530
Message-ID: <1353070323-5937-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135214_947118_6FFCA0C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Assign 'true' to the bool variable instead of needless typecasting.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index ba6bd49..575e7d7 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -1184,7 +1184,7 @@ static void reset_endpoint_states(struct htc_target *target)
 		INIT_LIST_HEAD(&ep->pipe.tx_lookup_queue);
 		INIT_LIST_HEAD(&ep->rx_bufq);
 		ep->target = target;
-		ep->pipe.tx_credit_flow_enabled = (bool) 1; /* FIXME */
+		ep->pipe.tx_credit_flow_enabled = true;
 	}
 }
 
-- 
1.7.0.4

