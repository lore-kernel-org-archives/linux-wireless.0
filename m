Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35803 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYFJMFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 08:05:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] nl80211: Fix comment merge error
Date: Tue, 10 Jun 2008 14:04:14 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806101404.14780.mb@bu3sch.de> (sfid-20080610_140600_575680_A2F34952)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comments ended up in the wrong place due to a merge error.

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2008-02-29 11:14:27.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2008-06-10 14:02:55.000000000 +0200
@@ -122,13 +122,13 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_STATION,
 	NL80211_CMD_DEL_STATION,
 
-	/* add commands here */
-
 	NL80211_CMD_GET_MPATH,
 	NL80211_CMD_SET_MPATH,
 	NL80211_CMD_NEW_MPATH,
 	NL80211_CMD_DEL_MPATH,
 
+	/* add commands here */
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -230,13 +230,13 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MNTR_FLAGS,
 
-	/* add attributes here, update the policy in nl80211.c */
-
 	NL80211_ATTR_MESH_ID,
 	NL80211_ATTR_STA_PLINK_ACTION,
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	/* add attributes here, update the policy in nl80211.c */
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };

-- 
Greetings Michael.
