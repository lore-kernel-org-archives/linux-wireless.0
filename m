Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44482 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0GLUPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 16:15:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Wu <aluminum.tape@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: mark adm8211 as an orphan
Date: Mon, 12 Jul 2010 16:05:08 -0400
Message-Id: <1278965108-10438-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 837a754..3075e55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -320,11 +320,9 @@ S:	Maintained
 F:	drivers/hwmon/adm1029.c
 
 ADM8211 WIRELESS DRIVER
-M:	Michael Wu <flamingice@sourmilk.net>
 L:	linux-wireless@vger.kernel.org
 W:	http://linuxwireless.org/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/adm8211.*
 
 ADT746X FAN DRIVER
-- 
1.7.1.1

