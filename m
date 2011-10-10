Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18793 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1JJPQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 34/34] iwlagn: add missing include to iwl-agn-rs.h
Date: Mon, 10 Oct 2011 07:27:19 -0700
Message-Id: <1318256839-31837-35-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171643_656265_3998105E)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A few were missing

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index bdae82e..f4f6deb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -27,6 +27,10 @@
 #ifndef __iwl_agn_rs_h__
 #define __iwl_agn_rs_h__
 
+#include <net/mac80211.h>
+
+#include "iwl-commands.h"
+
 struct iwl_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
-- 
1.7.0.4

