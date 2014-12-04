Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40100 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709AbaLDWAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 17:00:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: orphan rtl8180
Date: Thu,  4 Dec 2014 16:53:30 -0500
Message-Id: <1417730010-9847-1-git-send-email-linville@tuxdriver.com> (sfid-20141204_230020_271742_4DDD6CDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7ec37a396ffe..e3f40df47513 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7845,11 +7845,10 @@ S:	Maintained
 F:	drivers/media/dvb-frontends/rtl2832_sdr*
 
 RTL8180 WIRELESS DRIVER
-M:	"John W. Linville" <linville@tuxdriver.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
-S:	Maintained
+S:	Orphan
 F:	drivers/net/wireless/rtl818x/rtl8180/
 
 RTL8187 WIRELESS DRIVER
-- 
1.9.3

