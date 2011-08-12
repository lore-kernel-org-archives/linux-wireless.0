Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58299 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1HLCff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 22:35:35 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so609089iye.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 19:35:35 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v3 5/6] ieee80211: add mesh action codes
Date: Thu, 11 Aug 2011 19:35:14 -0700
Message-Id: <1313116515-26166-5-git-send-email-thomas@cozybit.com> (sfid-20110812_043538_076979_773C751E)
In-Reply-To: <1313116515-26166-1-git-send-email-thomas@cozybit.com>
References: <1313116515-26166-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/ieee80211.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2417b90..311df71 100644
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
1.7.4.1

