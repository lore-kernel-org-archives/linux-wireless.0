Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41891 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2GKGh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 02:37:29 -0400
Received: by wgbdr13 with SMTP id dr13so707711wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 23:37:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: fix typo - reading number of slave wrappers
Date: Wed, 11 Jul 2012 08:37:23 +0200
Message-Id: <1341988643-26116-1-git-send-email-zajec5@gmail.com> (sfid-20120711_083733_395772_EED6151A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/scan.h b/drivers/bcma/scan.h
index 113e6a6..30eb475 100644
--- a/drivers/bcma/scan.h
+++ b/drivers/bcma/scan.h
@@ -27,7 +27,7 @@
 #define SCAN_CIB_NMW		0x0007C000
 #define SCAN_CIB_NMW_SHIFT	14
 #define SCAN_CIB_NSW		0x00F80000
-#define SCAN_CIB_NSW_SHIFT	17
+#define SCAN_CIB_NSW_SHIFT	19
 #define SCAN_CIB_REV		0xFF000000
 #define SCAN_CIB_REV_SHIFT	24
 
-- 
1.7.7

