Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:15604 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752646AbZLCKjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:39:02 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/4] iwmc3200wifi: Update wiwi priority table
Date: Thu,  3 Dec 2009 11:40:15 +0100
Message-Id: <4790a128344a09f0bdb2249c8ee831f254ca72ec.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This update follows the firmware engineers recommendations.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index bd06307..6a22711 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -122,18 +122,18 @@ static struct coex_event iwm_sta_xor_prio_tbl[COEX_EVENTS_NUM] =
 static struct coex_event iwm_sta_cm_prio_tbl[COEX_EVENTS_NUM] =
 {
 	{1, 1, 0, COEX_UNASSOC_IDLE_FLAGS},
-	{4, 3, 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
+	{4, 4, 0, COEX_UNASSOC_MANUAL_SCAN_FLAGS},
 	{3, 3, 0, COEX_UNASSOC_AUTO_SCAN_FLAGS},
-	{5, 5, 0, COEX_CALIBRATION_FLAGS},
+	{6, 6, 0, COEX_CALIBRATION_FLAGS},
 	{3, 3, 0, COEX_PERIODIC_CALIBRATION_FLAGS},
-	{5, 4, 0, COEX_CONNECTION_ESTAB_FLAGS},
+	{6, 5, 0, COEX_CONNECTION_ESTAB_FLAGS},
 	{4, 4, 0, COEX_ASSOCIATED_IDLE_FLAGS},
 	{4, 4, 0, COEX_ASSOC_MANUAL_SCAN_FLAGS},
 	{4, 4, 0, COEX_ASSOC_AUTO_SCAN_FLAGS},
 	{4, 4, 0, COEX_ASSOC_ACTIVE_LEVEL_FLAGS},
 	{1, 1, 0, COEX_RF_ON_FLAGS},
 	{1, 1, 0, COEX_RF_OFF_FLAGS},
-	{6, 6, 0, COEX_STAND_ALONE_DEBUG_FLAGS},
+	{7, 7, 0, COEX_STAND_ALONE_DEBUG_FLAGS},
 	{5, 4, 0, COEX_IPAN_ASSOC_LEVEL_FLAGS},
 	{1, 1, 0, COEX_RSRVD1_FLAGS},
 	{1, 1, 0, COEX_RSRVD2_FLAGS}
-- 
1.6.3.3

