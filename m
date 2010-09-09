Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab0IINxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:53:04 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/12] iwlwifi: use IWL_DEBUG_SCAN
Date: Thu,  9 Sep 2010 15:52:23 +0200
Message-Id: <1284040354-31703-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index d31ed14..5fb49d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -158,7 +158,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
-	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
+	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
-- 
1.7.1

