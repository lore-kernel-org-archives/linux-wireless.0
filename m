Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15782 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbbJ1Ino (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 04:43:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: change MAINTAINERS
Date: Wed, 28 Oct 2015 17:43:27 +0900
Message-ID: <1446021807-2698-1-git-send-email-tony.cho@atmel.com> (sfid-20151028_094349_468206_3F82177E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes Rachel Kim from the MAINTAINERS list because she
retires from her position and adds Austin shin as new MAINTAINER for
the Atmel wireless link controller: WILC1000 and WILC3000.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8492117..cc27aef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10014,7 +10014,7 @@ F:	drivers/staging/vt665?/
 
 STAGING - WILC1000 WIFI DRIVER
 M:	Johnny Kim <johnny.kim@atmel.com>
-M:	Rachel Kim <rachel.kim@atmel.com>
+M:	Austin Shin <austin.shin@atmel.com>
 M:	Chris Park <chris.park@atmel.com>
 M:	Tony Cho <tony.cho@atmel.com>
 M:	Glen Lee <glen.lee@atmel.com>
-- 
1.9.1

