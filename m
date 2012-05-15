Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37619 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2EOOJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:22 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so2512825wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:22 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/10] wl18xx: add dependency on mac80211
Date: Tue, 15 May 2012 17:08:59 +0300
Message-Id: <1337090940-13750-9-git-send-email-arik@wizery.com> (sfid-20120515_160928_689240_FF335FFC)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a dependency on mac80211 in Kconfig, and also replace some spaces
with tabs.

Reported-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/Kconfig |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/Kconfig b/drivers/net/wireless/ti/wl18xx/Kconfig
index 1451d1f..1cfdb25 100644
--- a/drivers/net/wireless/ti/wl18xx/Kconfig
+++ b/drivers/net/wireless/ti/wl18xx/Kconfig
@@ -1,6 +1,7 @@
 config WL18XX
-       tristate "TI wl18xx support"
-       select WLCORE
-       ---help---
+	tristate "TI wl18xx support"
+	depends on MAC80211
+	select WLCORE
+	---help---
 	  This module adds support for wireless adapters based on TI
 	  WiLink 8 chipsets.
-- 
1.7.9.5

