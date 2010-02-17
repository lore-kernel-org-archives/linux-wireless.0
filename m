Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35893 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0BQQGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 11:06:05 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1HG5xf9030857
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 10:06:02 -0600
Received: from [127.0.1.1] (essapo-nirac253144.europe.nokia.com [10.162.253.144])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1HG5mIZ000879
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 18:05:48 +0200
Subject: [PATCH v2 2/3] iw: update nl80211.h to include power save commands
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 17 Feb 2010 18:05:47 +0200
Message-ID: <20100217160547.4598.91442.stgit@tikku>
In-Reply-To: <20100217155810.4534.69338.stgit@tikku>
References: <20100217155810.4534.69338.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 nl80211.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 8e6384f..28ba20f 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -416,6 +416,9 @@ enum nl80211_commands {
 	NL80211_CMD_ACTION,
 	NL80211_CMD_ACTION_TX_STATUS,
 
+	NL80211_CMD_SET_POWER_SAVE,
+	NL80211_CMD_GET_POWER_SAVE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -837,6 +840,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_ACK,
 
+	NL80211_ATTR_PS_STATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1573,4 +1578,9 @@ enum nl80211_band {
 	NL80211_BAND_5GHZ,
 };
 
+enum nl80211_ps_state {
+	NL80211_PS_DISABLED,
+	NL80211_PS_ENABLED,
+};
+
 #endif /* __LINUX_NL80211_H */

