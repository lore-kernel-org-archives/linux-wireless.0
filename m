Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYDUWmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/11] iwlwifi: remove includes to net/ieee80211.h
Date: Mon, 21 Apr 2008 15:41:54 -0700
Message-Id: <1208817721-11333-5-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_159339_D294DD29)
In-Reply-To: <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

this patch removes remaining includes to net/ieee80211.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 85c2264..e51eeef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -29,7 +29,6 @@
 #include <linux/skbuff.h>
 #include <linux/wireless.h>
 #include <net/mac80211.h>
-#include <net/ieee80211.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 557912a..e20c938 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -28,7 +28,6 @@
 #include <linux/skbuff.h>
 #include <linux/wireless.h>
 #include <net/mac80211.h>
-#include <net/ieee80211.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-- 
1.5.3.4

