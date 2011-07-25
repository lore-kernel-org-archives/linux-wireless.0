Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60750 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1GZAAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 20:00:12 -0400
Received: by pzk37 with SMTP id 37so9320782pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 17:00:12 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 5/6] ieee80211: add mesh action codes
Date: Mon, 25 Jul 2011 16:59:16 -0700
Message-Id: <1311638357-28740-6-git-send-email-thomas@cozybit.com> (sfid-20110726_020018_469503_079AB1B7)
In-Reply-To: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/ieee80211.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5ecf148..08b1093 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1305,6 +1305,21 @@ enum ieee80211_self_protected_actioncode {
 	WLAN_SP_MGK_ACK = 5,
 };
 
+/* Mesh action codes */
+enum ieee80211_mesh_actioncode {
+	WLAN_MESH_ACTION_LINK_METRIC_REPORT,
+	WLAN_MESH_ACTION_HWMP_PATH_SELECTION,
+	WLAN_MESH_ACTION_GATE_ANNOUNCEMENT,
+	WLAN_MESH_ACTION_CONGESTION_CONTROL_NOTIFICATION,
+	WLAN_MESH_ACTION_MCCA_SETUP_REQUEST,
+	WLAN_MESH_ACTION_MCCA_SETUP_REPLY,
+	WLAN_MESH_ACTION_MCCA_ADVERTISEMENT_REQUEST,
+	WLAN_MESH_ACTION_MCCA_ADVERTISEMENT,
+	WLAN_MESH_ACTION_MCCA_TEARDOWN,
+	WLAN_MESH_ACTION_TBTT_ADJUSTMENT_REQUEST,
+	WLAN_MESH_ACTION_TBTT_ADJUSTMENT_RESPONSE,
+};
+
 /* Security key length */
 enum ieee80211_key_len {
 	WLAN_KEY_LEN_WEP40 = 5,
-- 
1.7.6

