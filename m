Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab0GLPGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 11:06:30 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Wu <aluminum.tape@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] wireless: mark adm8211 and p54 orphaned
Date: Mon, 12 Jul 2010 11:06:29 -0400
Message-Id: <1278947189-14833-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael has been out of the scene for a while now, these
drivers are really orphaned so mark them as such.

Cc: Michael Wu <aluminum.tape@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 MAINTAINERS |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a07a49d..6ed6135 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -313,11 +313,10 @@ S:	Maintained
 F:	drivers/hwmon/adm1029.c
 
 ADM8211 WIRELESS DRIVER
-M:	Michael Wu <flamingice@sourmilk.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/adm8211.*
 
 ADT746X FAN DRIVER
@@ -4270,11 +4269,10 @@ F:	include/scsi/osd_*
 F:	fs/exofs/
 
 P54 WIRELESS DRIVER
-M:	Michael Wu <flamingice@sourmilk.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://prism54.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/p54/
 
 PA SEMI ETHERNET DRIVER
-- 
1.7.0.4

