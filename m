Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:51950 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab3LIU2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 15:28:35 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: luca@coelho.fi, balbi@ti.com
Subject: [PATCH] MAINTAINERS: remove myself as maintainer of TI WiLink drivers
Date: Mon,  9 Dec 2013 22:28:32 +0200
Message-Id: <1386620912-9292-1-git-send-email-luca@coelho.fi> (sfid-20131209_212838_766465_F15DB104)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't have the time to maintain the TI WiLink WLAN drivers anymore.
Remove my name and mark them as Orphan.

Signed-off-by: Luciano Coelho <luca@coelho.fi>
---

Unfortunately I don't have the time to maintain the WiLink drivers
anymore.  Does anyone want to step forward to take it over?

 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e65a2c2..265bf79 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8560,12 +8560,11 @@ S:	Maintained
 F:	sound/soc/codecs/twl4030*
 
 TI WILINK WIRELESS DRIVERS
-M:	Luciano Coelho <luca@coelho.fi>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/wl12xx
 W:	http://wireless.kernel.org/en/users/Drivers/wl1251
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/ti/
 F:	include/linux/wl12xx.h
 
-- 
1.8.5.1

