Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbYDXAPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 14/16] iwlwifi: iwl-sta redundant includes clean up
Date: Wed, 23 Apr 2008 17:15:06 -0700
Message-Id: <1208996108-15326-15-git-send-email-reinette.chatre@intel.com> (sfid-20080424_023545_746233_6F97B35E)
In-Reply-To: <1208996108-15326-14-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-9-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-10-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-11-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-12-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-13-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-14-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch cleans unnecessary includes in iwl-sta.[hc]

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    2 --
 drivers/net/wireless/iwlwifi/iwl-sta.h |    8 --------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d39ac1c..2eee598 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -36,8 +36,6 @@
 #include "iwl-sta.h"
 #include "iwl-io.h"
 #include "iwl-helpers.h"
-#include "iwl-4965.h"
-#include "iwl-sta.h"
 
 u8 iwl_find_station(struct iwl_priv *priv, const u8 *addr)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 8955835..38b1b0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -29,14 +29,6 @@
 #ifndef __iwl_sta_h__
 #define __iwl_sta_h__
 
-#include <net/mac80211.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-core.h"
-#include "iwl-4965.h"
-#include "iwl-io.h"
-#include "iwl-helpers.h"
-
 int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty);
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
-- 
1.5.3.4

