Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab1D1Jwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:34 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/10] iwlegacy: remove duplicate initialization in iwl4956_down()
Date: Thu, 28 Apr 2011 11:51:24 +0200
Message-Id: <1303984293-6601-1-git-send-email-sgruszka@redhat.com> (sfid-20110428_115242_223655_8AEF5A51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index ad05f2e..644bf31 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -2139,7 +2139,7 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv);
 static void __iwl4965_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
+	int exit_pending;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-- 
1.7.1

