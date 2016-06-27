Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:39834 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbcF0OKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 10:10:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <luisbg@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
CC: <loic.lefort@atmel.com>, <aditya.shankar@microchip.com>,
	<ganesh.krishna@microchip.com>, <devel@driverdev.osuosl.org>,
	Aditya Shankar <Aditya.Shankar@microchip.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] MAINTAINERS: Update maintainer entry for wilc1000
Date: Mon, 27 Jun 2016 16:10:29 +0200
Message-ID: <20160627141029.30653-1-nicolas.ferre@atmel.com> (sfid-20160627_161036_104953_73FDAAA5)
In-Reply-To: <20160625221744.GB11632@kroah.com>
References: <20160625221744.GB11632@kroah.com>
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
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Hi Luis, Greg, 

I'd like that we don't delete the entry for this wilc1000 driver
but change it with the patch below.
After the Microchip - Atmel merger, Aditya and Ganesh will take over the
maintenance of this driver and will continue the work that our former
colleagues started.

Thanks, bye.

 MAINTAINERS | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51447a517095..9142e08ba8ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10931,12 +10931,8 @@ S:	Odd Fixes
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

