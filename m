Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYAaGKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:10:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/5] iwlwifi: remove ieee80211 types from iwl-helpers.h
Date: Wed, 30 Jan 2008 22:05:14 -0800
Message-Id: <1201759516-28963-4-git-send-email-reinette.chatre@intel.com> (sfid-20080131_061035_297603_15DD6FA6)
In-Reply-To: <1201759516-28963-3-git-send-email-reinette.chatre@intel.com>
References: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-2-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes IEEE80211_STYPE_BACK_REQ and
IEEE80211_STYPE_BACK defines from iwl-helpers.h. These are already
defined in include/linux/ieee80211.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index cb009f4..8993cca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -147,9 +147,6 @@ static inline struct ieee80211_conf *ieee80211_get_hw_conf(
 
 #define QOS_CONTROL_LEN 2
 
-#define IEEE80211_STYPE_BACK_REQ	0x0080
-#define IEEE80211_STYPE_BACK		0x0090
-
 
 static inline int ieee80211_is_management(u16 fc)
 {
-- 
1.5.3.4

