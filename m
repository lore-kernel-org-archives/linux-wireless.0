Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab0GVTAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:00:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Jean Tourrilhes <jt@hpl.hp.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: remove entry for wavelan
Date: Thu, 22 Jul 2010 14:47:02 -0400
Message-Id: <1279824422-21711-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver is already removed from drivers/staging.  The wireless
extensions part is not really valid anymore either, since wext got moved
and refactored, etc.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 220a4ba..f160c77 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6177,14 +6177,6 @@ F:	Documentation/watchdog/
 F:	drivers/watchdog/
 F:	include/linux/watchdog.h
 
-WAVELAN NETWORK DRIVER & WIRELESS EXTENSIONS
-M:	Jean Tourrilhes <jt@hpl.hp.com>
-L:	linux-wireless@vger.kernel.org
-W:	http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/
-S:	Maintained
-F:	Documentation/networking/wavelan.txt
-F:	drivers/staging/wavelan/
-
 WD7000 SCSI DRIVER
 M:	Miroslav Zagorac <zaga@fly.cc.fer.hr>
 L:	linux-scsi@vger.kernel.org
-- 
1.7.1.1

