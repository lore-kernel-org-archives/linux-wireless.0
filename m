Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYKGR6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/13] iwlwifi: trivial fix in includes
Date: Fri,  7 Nov 2008 09:58:36 -0800
Message-Id: <1226080726-24860-4-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185821_340262_17887B61)
In-Reply-To: <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes one FIXME: in rearranging includes

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8eb0203..ec474db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -30,10 +30,9 @@
 #include <linux/module.h>
 #include <net/mac80211.h>
 
-struct iwl_priv; /* FIXME: remove */
-#include "iwl-debug.h"
 #include "iwl-eeprom.h"
 #include "iwl-dev.h" /* FIXME: remove */
+#include "iwl-debug.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-rfkill.h"
-- 
1.5.4.3

