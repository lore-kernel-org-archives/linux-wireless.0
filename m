Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43364 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCIG53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:29 -0500
Subject: [PATCH 4/6] ath6kl: remove unnecessary line continuations
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:29 +0200
Message-ID: <20140309065729.10793.45052.stgit@x230> (sfid-20140309_075731_677733_6F89F965)
In-Reply-To: <20140309065606.10793.67068.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warning:

WARNING: Avoid unnecessary line continuations

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 4b46adb..e64e4c9 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -45,8 +45,9 @@ module_param(testmode, uint, 0644);
 module_param(recovery_enable, uint, 0644);
 module_param(heart_beat_poll, uint, 0644);
 MODULE_PARM_DESC(recovery_enable, "Enable recovery from firmware error");
-MODULE_PARM_DESC(heart_beat_poll, "Enable fw error detection periodic"   \
-		 "polling. This also specifies the polling interval in"  \
+MODULE_PARM_DESC(heart_beat_poll,
+		 "Enable fw error detection periodic"
+		 "polling. This also specifies the polling interval in"
 		 "msecs. Set reocvery_enable for this to be effective");
 
 void ath6kl_core_tx_complete(struct ath6kl *ar, struct sk_buff *skb)

