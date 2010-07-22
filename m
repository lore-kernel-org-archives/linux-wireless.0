Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44300 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324Ab0GVSpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Simon Kelley <simon@thekelleys.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: orphan the atmel wireless driver
Date: Thu, 22 Jul 2010 14:31:08 -0400
Message-Id: <1279823468-21366-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3148b71..2911648 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1170,11 +1170,10 @@ S:	Supported
 F:	drivers/usb/gadget/atmel_usba_udc.*
 
 ATMEL WIRELESS DRIVER
-M:	Simon Kelley <simon@thekelleys.org.uk>
 L:	linux-wireless@vger.kernel.org
 W:	http://www.thekelleys.org.uk/atmel
 W:	http://atmelwlandriver.sourceforge.net/
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/atmel*
 
 AUDIT SUBSYSTEM
-- 
1.7.1.1

