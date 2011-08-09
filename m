Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62252 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HITvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:51:31 -0400
Received: by yie30 with SMTP id 30so247663yie.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 12:51:31 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 5/6] ieee80211: add mesh action codes
Date: Tue,  9 Aug 2011 12:50:17 -0700
Message-Id: <1312919418-32196-6-git-send-email-thomas@cozybit.com> (sfid-20110809_215135_222247_BB168719)
In-Reply-To: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
References: <1312919418-32196-1-git-send-email-thomas@cozybit.com>
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
1.7.6

