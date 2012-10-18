Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:58051 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2JRDVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 23:21:46 -0400
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH] mac80211: fix copy-paste typo in Kconfig
Date: Wed, 17 Oct 2012 20:21:30 -0700
Message-Id: <1350530490-5139-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121018_052150_715348_EA8062FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 63af254..b4ecf26 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -248,7 +248,7 @@ config MAC80211_MHWMP_DEBUG
 	  Do not select this option.
 
 config MAC80211_MESH_SYNC_DEBUG
-	bool "Verbose mesh mesh synchronization debugging"
+	bool "Verbose mesh synchronization debugging"
 	depends on MAC80211_DEBUG_MENU
 	depends on MAC80211_MESH
 	---help---
-- 
1.7.9.5

