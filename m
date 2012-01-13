Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34406 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2AMVzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 16:55:17 -0500
Received: by eaal12 with SMTP id l12so332533eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2012 13:55:16 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3 1/2] MAINTAINERS: move BCMA to keep the list sorted
Date: Fri, 13 Jan 2012 22:55:05 +0100
Message-Id: <1326491706-14970-1-git-send-email-zajec5@gmail.com> (sfid-20120113_225521_700237_BE7DC5DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V3: S-o-b
---
 MAINTAINERS |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4babed7..dc11e28 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1595,6 +1595,13 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2fc/
 
+BROADCOM SPECIFIC AMBA DRIVER (BCMA)
+M:	Rafał Miłecki <zajec5@gmail.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/bcma/
+F:	include/linux/bcma/
+
 BROCADE BFA FC SCSI DRIVER
 M:	Jing Huang <huangj@brocade.com>
 L:	linux-scsi@vger.kernel.org
@@ -6101,13 +6108,6 @@ S:	Maintained
 F:	drivers/ssb/
 F:	include/linux/ssb/
 
-BROADCOM SPECIFIC AMBA DRIVER (BCMA)
-M:	Rafał Miłecki <zajec5@gmail.com>
-L:	linux-wireless@vger.kernel.org
-S:	Maintained
-F:	drivers/bcma/
-F:	include/linux/bcma/
-
 SONY VAIO CONTROL DEVICE DRIVER
 M:	Mattia Dongili <malattia@linux.it>
 L:	platform-driver-x86@vger.kernel.org
-- 
1.7.7

