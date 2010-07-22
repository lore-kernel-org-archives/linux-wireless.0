Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44301 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368Ab0GVSpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 14:45:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Jeroen Vreeken <pe1rxq@amsat.org>, linux-usb@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: orphan the zd1201 wireless driver
Date: Thu, 22 Jul 2010 14:42:49 -0400
Message-Id: <1279824169-21654-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 79b0679..220a4ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5989,10 +5989,9 @@ F:	Documentation/video4linux/zc0301.txt
 F:	drivers/media/video/zc0301/
 
 USB ZD1201 DRIVER
-M:	Jeroen Vreeken <pe1rxq@amsat.org>
-L:	linux-usb@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 W:	http://linux-lc100020.sourceforge.net
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/zd1201.*
 
 USB ZR364XX DRIVER
-- 
1.7.1.1

