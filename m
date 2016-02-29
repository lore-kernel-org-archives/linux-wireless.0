Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:19374 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbcB2JE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 04:04:28 -0500
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <chris.park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: wilc_wlan_if.h: remove unused functions
Date: Mon, 29 Feb 2016 18:02:39 +0900
Message-ID: <1456736559-661-1-git-send-email-tony.cho@atmel.com> (sfid-20160229_100442_871763_FF8A8029)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the unused functions anymore related to the configuration
of the bus interface clock speed.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index fbe34eb..f19ecb5 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -918,8 +918,6 @@ typedef enum {
 
 struct wilc;
 int wilc_wlan_init(struct net_device *dev);
-void wilc_bus_set_max_speed(void);
-void wilc_bus_set_default_speed(void);
 u32 wilc_get_chipid(struct wilc *wilc, bool update);
 
 #endif
-- 
1.9.1

