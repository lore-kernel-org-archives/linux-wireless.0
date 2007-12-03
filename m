Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXLCLpe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:34 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 03/34] iwl3945: re-align 3945 event log data
Date: Mon,  3 Dec 2007 13:43:15 +0200
Message-Id: <11966822293932-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120554_742986_D69BFEED)
In-Reply-To: <1196682229843-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Re-align 3945 event log data.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index efeb933..415dbc9 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4494,7 +4494,7 @@ static void iwl3945_dump_nic_error_log(struct iwl3945_priv *priv)
 
 }
 
-#define EVENT_START_OFFSET  (4 * sizeof(u32))
+#define EVENT_START_OFFSET  (6 * sizeof(u32))
 
 /**
  * iwl3945_print_event_log - Dump error event log to syslog
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
