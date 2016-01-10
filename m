Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34081 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbcAJRl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2016 12:41:57 -0500
Received: by mail-wm0-f68.google.com with SMTP id b14so23161061wmb.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2016 09:41:57 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] cfg80211: Fix some linguistics in Kconfig
Date: Sun, 10 Jan 2016 18:41:42 +0100
Message-Id: <1452447702-4587-1-git-send-email-ola1olsson@gmail.com> (sfid-20160110_184200_831097_F261D39E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/Kconfig |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index ec3bf30..6c60612 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -50,8 +50,8 @@ config CFG80211_DEVELOPER_WARNINGS
 	default n
 	help
 	  This option enables some additional warnings that help
-	  cfg80211 developers and driver developers, but that can
-	  trigger due to races with userspace.
+	  cfg80211 developers and driver developers, but beware that
+	  they can also trigger due to races with userspace.
 
 	  For example, when a driver reports that it was disconnected
 	  from the AP, but the user disconnects manually at the same
@@ -110,7 +110,7 @@ config CFG80211_REG_RELAX_NO_IR
 	 interface which associated to an AP which userspace assumes or confirms
 	 to be an authorized master, i.e., with radar detection support and DFS
 	 capabilities. However, note that in order to not create daisy chain
-	 scenarios, this relaxation is not allowed in cases that the BSS client
+	 scenarios, this relaxation is not allowed in cases where the BSS client
 	 is associated to P2P GO and in addition the P2P GO instantiated on
 	 a channel due to this relaxation should not allow connection from
 	 non P2P clients.
@@ -135,7 +135,7 @@ config CFG80211_DEBUGFS
 	depends on CFG80211
 	depends on DEBUG_FS
 	---help---
-	  You can enable this if you want to debugfs entries for cfg80211.
+	  You can enable this if you want debugfs entries for cfg80211.
 
 	  If unsure, say N.
 
@@ -146,7 +146,7 @@ config CFG80211_INTERNAL_REGDB
 	---help---
 	  This option generates an internal data structure representing
 	  the wireless regulatory rules described in net/wireless/db.txt
-	  and includes code to query that database.  This is an alternative
+	  and includes code to query that database. This is an alternative
 	  to using CRDA for defining regulatory rules for the kernel.
 
 	  Using this option requires some parsing of the db.txt at build time,
@@ -159,7 +159,7 @@ config CFG80211_INTERNAL_REGDB
 
 	  http://wireless.kernel.org/en/developers/Regulatory
 
-	  Most distributions have a CRDA package.  So if unsure, say N.
+	  Most distributions have a CRDA package. So if unsure, say N.
 
 config CFG80211_CRDA_SUPPORT
 	bool "support CRDA" if CFG80211_INTERNAL_REGDB
-- 
1.7.9.5

