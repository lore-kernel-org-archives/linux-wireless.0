Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:35033 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZHJIPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 04:15:47 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@iki.fi, joe@perches.com
Subject: [PATCH v2] MAINTAINERS: add information for wl1271 wireless driver
Date: Mon, 10 Aug 2009 11:15:13 +0300
Message-Id: <1249892113-25090-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add maintainer information section for the wl1271 wireless driver and fix the
information for wl1271.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 MAINTAINERS |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f2f7156..3c22ee0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5570,7 +5570,16 @@ L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
-F:	drivers/net/wireless/wl12xx/wl1251*
+F:	drivers/net/wireless/wl12xx/*
+X:	drivers/net/wireless/wl12xx/wl1271*
+
+WL1271 WIRELESS DRIVER
+M:	Luciano Coelho <luciano.coelho@nokia.com>
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:	Maintained
+F:	drivers/net/wireless/wl12xx/wl1271*
 
 WL3501 WIRELESS PCMCIA CARD DRIVER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
-- 
1.6.0.4

