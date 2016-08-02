Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41063 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbcHBJtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 05:49:10 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <luisbg@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
CC: <loic.lefort@atmel.com>, <aditya.shankar@microchip.com>,
	<ganesh.krishna@microchip.com>, <devel@driverdev.osuosl.org>,
	Aditya Shankar <Aditya.Shankar@microchip.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [RESEND PATCH] MAINTAINERS: Update maintainer entry for wilc1000
Date: Tue, 2 Aug 2016 11:49:00 +0200
Message-ID: <20160802094900.5619-1-nicolas.ferre@atmel.com> (sfid-20160802_114917_922724_BB5E6068)
In-Reply-To: <578424eb.gTszFlACY5dPKGsR%akpm@linux-foundation.org>
References: <578424eb.gTszFlACY5dPKGsR%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aditya Shankar <Aditya.Shankar@microchip.com>

Take the maintenance of the Atmel WIFI staging driver wilc1000.
Former maintainers are no more with Atmel.

Reported-by: Loic Lefort <loic.lefort@atmel.com>
Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
Signed-off-by: Ganesh Krishna <ganesh.krishna@microchip.com>
Acked-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi all,

Just an elaborate "ping" with the Acked-by tag from Luis added.
As noted by Luis, previous version of this patch is here:
https://lkml.org/lkml/2016/6/27/382

Thanks, bye.

 MAINTAINERS | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 33d7e2252ceb..b0d5c77c9db2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11202,12 +11202,8 @@ S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
 STAGING - WILC1000 WIFI DRIVER
-M:	Johnny Kim <johnny.kim@atmel.com>
-M:	Austin Shin <austin.shin@atmel.com>
-M:	Chris Park <chris.park@atmel.com>
-M:	Tony Cho <tony.cho@atmel.com>
-M:	Glen Lee <glen.lee@atmel.com>
-M:	Leo Kim <leo.kim@atmel.com>
+M:	Aditya Shankar <aditya.shankar@microchip.com>
+M:	Ganesh Krishna <ganesh.krishna@microchip.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/staging/wilc1000/
-- 
2.9.0

