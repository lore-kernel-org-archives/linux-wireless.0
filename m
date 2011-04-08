Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab1DHPuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/16] iwlagn: no 3945 define needed
Date: Fri,  8 Apr 2011 08:30:26 -0700
Message-Id: <1302276636-12802-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove 3945 define

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 69a2993..bdae82e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -83,7 +83,6 @@ enum {
 
 enum {
 	IWL_FIRST_OFDM_RATE = IWL_RATE_6M_INDEX,
-	IWL39_LAST_OFDM_RATE = IWL_RATE_54M_INDEX,
 	IWL_LAST_OFDM_RATE = IWL_RATE_60M_INDEX,
 	IWL_FIRST_CCK_RATE = IWL_RATE_1M_INDEX,
 	IWL_LAST_CCK_RATE = IWL_RATE_11M_INDEX,
-- 
1.7.0.4

