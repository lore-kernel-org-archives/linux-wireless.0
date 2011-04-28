Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592Ab1D1Jw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:56 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/10] iwlegacy: comment typo fix diable -> disable
Date: Thu, 28 Apr 2011 11:51:30 +0200
Message-Id: <1303984293-6601-7-git-send-email-sgruszka@redhat.com> (sfid-20110428_115307_377013_C8DF9D19)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 7211c92..4b244fe 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -2642,7 +2642,7 @@ unplugged:
 
 none:
 	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if diabled by irq */
+	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_legacy_enable_interrupts(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 46966e9..871e13b 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1069,7 +1069,7 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	}
 
 	/* Re-enable all interrupts */
-	/* only Re-enable if diabled by irq */
+	/* only Re-enable if disabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_legacy_enable_interrupts(priv);
 	/* Re-enable RF_KILL if it occurred */
-- 
1.7.1

