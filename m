Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63717 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2ALQ1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 11:27:23 -0500
Received: by eaal12 with SMTP id l12so710351eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 08:27:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=201/2=5D=20MAINTAINERS=3A=20move=20BCMA=20to=20keep=20the=20list=20sorted?=
Date: Thu, 12 Jan 2012 17:28:59 +0100
Message-Id: <1326385740-11203-2-git-send-email-zajec5@gmail.com> (sfid-20120112_172743_005895_49342E3D)
In-Reply-To: <1326385740-11203-1-git-send-email-zajec5@gmail.com>
References: <1326385740-11203-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

