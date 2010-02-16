Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46284 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab0BPUNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:13:22 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GKD4vE028908
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 22:13:19 +0200
Received: from [127.0.1.1] (essapo-nirac25384.europe.nokia.com [10.162.253.84])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GKDA1P008277
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 22:13:10 +0200
Subject: [RFC PATCH 1/2] iw: update nl80211.h to include power save commands
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Feb 2010 22:13:09 +0200
Message-ID: <20100216201309.25291.8789.stgit@tikku>
In-Reply-To: <20100216201026.25148.40799.stgit@tikku>
References: <20100216201026.25148.40799.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 nl80211.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 127a730..1567175 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -387,6 +387,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
+	NL80211_CMD_SET_POWER_SAVE,
+	NL80211_CMD_GET_POWER_SAVE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -798,6 +801,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_RATES,
 
+	NL80211_ATTR_PS_STATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1534,4 +1539,9 @@ enum nl80211_band {
 	NL80211_BAND_5GHZ,
 };
 
+enum nl80211_ps_state {
+	NL80211_PS_DISABLED,
+	NL80211_PS_ENABLED,
+};
+
 #endif /* __LINUX_NL80211_H */

