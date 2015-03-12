Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbbCLNGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/49] iwlwifi: mvm: remove unneeded include iwl-fw-error-dump.h
Date: Thu, 12 Mar 2015 15:04:15 +0200
Message-Id: <1426165474-25586-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_419400_A76A33AE)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions related to firmware error dump moved. No need
for this unclude anymore.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7b555f6..f94b322 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -82,7 +82,6 @@
 #include "rs.h"
 #include "fw-api-scan.h"
 #include "time-event.h"
-#include "iwl-fw-error-dump.h"
 
 #define DRV_DESCRIPTION	"The new Intel(R) wireless AGN driver for Linux"
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
1.9.1

