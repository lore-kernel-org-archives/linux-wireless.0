Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25629 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbEKFcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 01:32:13 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <chris.park@atmel.com>, <rachel.kim@atmel.com>,
	<dean.lee@atmel.com>, <tony.cho@atmel.com>,
	<Nicolas.FERRE@atmel.com>, Johnny Kim <johnny.kim@atmel.com>
Subject: [PATCH v3 2/2] staging: MAINTAINERS: add maintainer for wilc1000 device
Date: Mon, 11 May 2015 14:30:57 +0900
Message-ID: <9625b49f6744c9343b21b5c81f5f98f53e59de11.1431320004.git.johnny.kim@atmel.com> (sfid-20150511_073218_288352_EDADA873)
In-Reply-To: <b442bf7ee73817953edb91ab0646d6371b6e71b3.1431320004.git.johnny.kim@atmel.com>
References: <b442bf7ee73817953edb91ab0646d6371b6e71b3.1431320004.git.johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add myself as maintainer for atmel wilc1000

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Rachel Kim <rachel.kim@atmel.com>
Signed-off-by: Dean Lee <dean.lee@atmel.com>
Signed-off-by: Chris Park <chris.park@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Changes in v3:
- fix the permissions.
- fix the folder tree.
- forget to add the mailing-list during the previous sending.
- remove driverdev.osuosl.org mailing

 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1b8263c..e5cef88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9473,6 +9473,15 @@ M:	Forest Bond <forest@alittletooquiet.net>
 S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
+STAGING - WILC1000 WIFI DRIVER
+M:	Johnny Kim <johnny.kim@atmel.com>
+M:	Rachel Kim <rachel.kim@atmel.com>
+M:	Dean Lee <dean.lee@atmel.com>
+M:	Chris Park <chris.park@atmel.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/staging/wilc1000/
+
 STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
 M:	Arnaud Patard <arnaud.patard@rtp-net.org>
 S:	Odd Fixes
-- 
1.9.1

