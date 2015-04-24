Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18522 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbDXKUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:20:39 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
	<devel@driverdev.osuosl.org>
CC: <tony.cho@atmel.com>, <DL-NMI-KR-Kernel@atmel.com>,
	<Nicolas.FERRE@atmel.com>, Johnny Kim <johnny.kim@atmel.com>
Subject: [PATCH 2/2] staging: MAINTAINERS: add maintainer for wilc1000 device
Date: Fri, 24 Apr 2015 19:20:01 +0900
Message-ID: <33946bb15be3cff34ef21668c40cf28ceee820eb.1429868048.git.johnny.kim@atmel.com> (sfid-20150424_122042_480481_57BEC7C3)
In-Reply-To: <8899ee1d8570c87be1934c685f188b8f04d374b6.1429868048.git.johnny.kim@atmel.com>
References: <8899ee1d8570c87be1934c685f188b8f04d374b6.1429868048.git.johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add myself as maintainer for atmel wilc1000

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
Signed-off-by: Rachel Kim <rachel.kim@atmel.com>
Signed-off-by: Dean Lee <dean.lee@atmel.com>
Signed-off-by: Chris Park <chris.park@atmel.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1b8263c..e4252b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9473,6 +9473,16 @@ M:	Forest Bond <forest@alittletooquiet.net>
 S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
+STAGING - WILC1000 WIFI DRIVER
+M:	Johnny Kim <johnny.kim@atmel.com>
+M:	Rachel Kim <rachel.kim@atmel.com>
+M:	Dean Lee <dean.lee@atmel.com>
+M:	Chris Park <chris.park@atmel.com>
+L:	devel@driverdev.osuosl.org
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/staging/atmel/wilc1000/
+
 STAGING - XGI Z7,Z9,Z11 PCI DISPLAY DRIVER
 M:	Arnaud Patard <arnaud.patard@rtp-net.org>
 S:	Odd Fixes
-- 
1.9.1

