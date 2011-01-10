Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48564 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab1AJQCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 11:02:03 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0AG21at032577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 10:02:01 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0AG216Q020238
	for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 10:02:01 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0AG218J009095
	for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 10:02:01 -0600 (CST)
Received: from pimenta.emea.dhcp.ti.com (pimenta.emea.dhcp.ti.com
 [137.167.41.166])	by dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id
 p0AG1xSm026900	for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011
 10:02:00 -0600
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: update information for the wl12xx driver
Date: Mon, 10 Jan 2011 18:02:10 +0200
Message-ID: <1294675330-11691-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Update maintainer's email address, webpage and align with renaming of
files.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ff19c30..92394cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6540,12 +6540,12 @@ S:	Maintained
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

