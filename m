Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:41953 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZHGVuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 17:50:12 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n77LnsaN003709
	for <linux-wireless@vger.kernel.org>; Sat, 8 Aug 2009 00:49:59 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com
Subject: [PATCH] MAINTAINERS: add information for wl1271 wireless driver
Date: Sat,  8 Aug 2009 00:50:05 +0300
Message-Id: <1249681805-21015-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add maintainer information section for the wl1271 wireless driver and fix the
information for wl1271.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 MAINTAINERS |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f2f7156..a529544 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5570,7 +5570,17 @@ L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
-F:	drivers/net/wireless/wl12xx/wl1251*
+F:	drivers/net/wireless/wl12xx/*
+X:	drivers/net/wireless/wl12xx/wl1271*
+
+WL1271 WIRELESS DRIVER
+P:	Luciano Coelho
+M:	luciano.coelho@nokia.com
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:	Maintained
+F:	drivers/net/wireless/wl12xx/wl1271*
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
-- 
1.6.0.4

