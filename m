Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27917 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbIJC6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 22:58:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: remove BROKEN status
Date: Thu, 10 Sep 2015 11:59:11 +0900
Message-ID: <1441853951-10523-1-git-send-email-tony.cho@atmel.com> (sfid-20150910_045851_858713_53BE9254)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes BROKEN status from the Kconfig.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index 51bbf46..59ccecc 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -1,6 +1,5 @@
 config WILC1000
 	tristate "WILC1000 support (WiFi only)"
-	depends on BROKEN
 	depends on !S390
 	depends on CFG80211 && WEXT_CORE && INET
 	depends on MMC || SPI
-- 
1.9.1

