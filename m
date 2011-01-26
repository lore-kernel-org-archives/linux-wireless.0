Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37481 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab1AZT5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 14:57:21 -0500
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-2.6] MAINTAINERS: update information for the wl12xx driver
Date: Wed, 26 Jan 2011 21:46:29 +0200
Message-Id: <1296071189-761-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update maintainer's email address, webpage and align with renaming of
files.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9ec9d8..a5deb42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6612,12 +6612,12 @@ S:	Maintained
 F:	drivers/net/wireless/wl1251/*
 
 WL1271 WIRELESS DRIVER
-M:	Luciano Coelho <luciano.coelho@nokia.com>
+M:	Luciano Coelho <coelho@ti.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://wireless.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/wl12xx
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
 S:	Maintained
-F:	drivers/net/wireless/wl12xx/wl1271*
+F:	drivers/net/wireless/wl12xx/
 F:	include/linux/wl12xx.h
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
-- 
1.7.1

