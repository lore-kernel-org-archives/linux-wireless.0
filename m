Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZIKIna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 04:43:30 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wireless: default CONFIG_WLAN to y
Date: Fri, 11 Sep 2009 04:43:29 -0400
Message-Id: <1252658609-3423-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this was added no defaults were set and it seems
this implies n. Default this to y.

Reported-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index ad89d23..49ea9c9 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -5,6 +5,7 @@
 menuconfig WLAN
 	bool "Wireless LAN"
 	depends on !S390
+	default y
 	---help---
 	  This section contains all the pre 802.11 and 802.11 wireless
 	  device drivers. For a complete list of drivers and documentation
-- 
1.6.3.3

