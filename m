Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab0HRQSd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:18:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/16] iwlwifi: max/min aggregation time limit
Date: Wed, 18 Aug 2010 09:22:38 -0700
Message-Id: <1282148571-9258-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282148571-9258-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the minimum and maximum for aggregation time limit in uSec.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9435fd9..c6a0470 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2092,8 +2092,8 @@ struct iwl_link_qual_general_params {
 } __packed;
 
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
-#define LINK_QUAL_AGG_TIME_LIMIT_MAX	(65535)
-#define LINK_QUAL_AGG_TIME_LIMIT_MIN	(0)
+#define LINK_QUAL_AGG_TIME_LIMIT_MAX	(8000)
+#define LINK_QUAL_AGG_TIME_LIMIT_MIN	(100)
 
 #define LINK_QUAL_AGG_DISABLE_START_DEF	(3)
 #define LINK_QUAL_AGG_DISABLE_START_MAX	(255)
-- 
1.7.0.4

