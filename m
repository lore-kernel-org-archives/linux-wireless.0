Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57262 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZG0XU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:20:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:20:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH] rt2x00: remove experimental on kconfig
Date: Mon, 27 Jul 2009 16:20:54 -0700
Message-ID: <1248736854-443-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These have been around for a while, if there are issues
they should be reported.

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Ivo, is this fair to say? Was surprised to see rt2x00 marked
as experimental still.

 drivers/net/wireless/rt2x00/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f970aa2..379da5c 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,8 +1,8 @@
 menuconfig RT2X00
 	tristate "Ralink driver support"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211
 	---help---
-	  This will enable the experimental support for the Ralink drivers,
+	  This will enable the support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
 
 	  These drivers make use of the mac80211 stack.
-- 
1.6.3.3

