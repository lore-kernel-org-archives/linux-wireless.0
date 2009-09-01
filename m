Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11579 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZIAPxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:53:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:53:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 3/7] wireless: update cfg80211 kconfig entry
Date: Tue, 1 Sep 2009 08:53:49 -0700
Message-ID: <1251820429-11003-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 is now *the* wireless configuration API. Lets also
give a little explanation as to what it is and refer people to
the wireless wiki for more information.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Changes description of when we build cfg80211 as a module
as pointed out by Larry.

 net/wireless/Kconfig |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index aea7e68..9fd570b 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,6 +1,15 @@
 config CFG80211
-	tristate "Improved wireless configuration API"
+	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
+	---help---
+	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
+	  Enable this if you have a wireless device.
+
+	  For more information refer to documentation on the wireless wiki:
+
+	  http://wireless.kernel.org/en/developers/Documentation/cfg80211
+
+	  When built as a module it will be called cfg80211.
 
 config NL80211_TESTMODE
 	bool "nl80211 testmode command"
-- 
1.6.3.3

