Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:60670 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946554AbXD3SRH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 14:17:07 -0400
Date: Mon, 30 Apr 2007 20:17:42 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: mark as experimental
Message-ID: <20070430201742.1f53aa40@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the stack depend on EXPERIMENTAL. Also, change the name from "dscape"
to "mac80211".

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- mac80211.orig/net/mac80211/Kconfig
+++ mac80211/net/mac80211/Kconfig
@@ -1,5 +1,6 @@
 config MAC80211
-	tristate "Generic IEEE 802.11 Networking Stack (dscape)"
+	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
+	depends on EXPERIMENTAL
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_ARC4



-- 
Jiri Benc
SUSE Labs
