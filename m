Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab3J3UcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 16:32:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 8/9] iwlwifi: remove duplicate includes
Date: Wed, 30 Oct 2013 22:31:36 +0200
Message-Id: <1383165097-4445-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131030_213224_418223_6069BA3F)
In-Reply-To: <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
References: <527143AA.5070900@gmail.com>
 <1383165097-4445-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Reported by "make includecheck"

Tested that the corresponding sources still compile well on x86

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c  | 1 -
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index dfa4d2e..ad8e19a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -34,7 +34,6 @@
 #include "iwl-csr.h"
 #include "iwl-debug.h"
 #include "iwl-fh.h"
-#include "iwl-csr.h"
 
 #define IWL_POLL_INTERVAL 10	/* microseconds */
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6235cb7..fed21ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -73,7 +73,6 @@
 #include "iwl-trans.h"
 #include "iwl-notif-wait.h"
 #include "iwl-eeprom-parse.h"
-#include "iwl-trans.h"
 #include "sta.h"
 #include "fw-api.h"
 #include "constants.h"
-- 
1.8.3.2

