Return-path: <linux-wireless-owner@vger.kernel.org>
Message-Id: <4D5D32630200007800032642@vpn.id2.novell.com>
Date: Thu, 17 Feb 2011 13:36:19 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <johannes@sipsolutions.net>
Cc: <linux-kbuild@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] small adjustment to net/mac80211/Kconfig
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"def_bool n" without prompt is pointless, this should be just "bool".

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 net/mac80211/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.38-rc5/net/mac80211/Kconfig
+++ 2.6.38-rc5-kconfig-mac80211/net/mac80211/Kconfig
@@ -17,7 +17,7 @@ comment "CFG80211 needs to be enabled fo
 if MAC80211 != n
 
 config MAC80211_HAS_RC
-	def_bool n
+	bool
 
 config MAC80211_RC_PID
 	bool "PID controller based rate control algorithm" if EXPERT



