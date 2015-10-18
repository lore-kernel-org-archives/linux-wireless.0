Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-138.163.com ([123.125.50.138]:57854 "EHLO m50-138.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbbJRPcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 11:32:48 -0400
From: Geliang Tang <geliangtang@163.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Kosina <trivial@kernel.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] staging: wilc1000: fix trivial typos
Date: Sun, 18 Oct 2015 23:31:11 +0800
Message-Id: <eb89ced1dda5b521dba1ed6095deef09d577e37a.1445181079.git.geliangtang@163.com> (sfid-20151018_173326_499173_1D17060C)
In-Reply-To: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com>
References: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com>
In-Reply-To: <918fdb002ec3b2a9fc5a5d364c0fbaff2f77c5cc.1445181079.git.geliangtang@163.com>
References: <949f6f3c99f87b57666986dc9f2d1c916935e215.1445181079.git.geliangtang@163.com> <557286dd38beb4d8d1be28e787ad89611e7cc077.1445181079.git.geliangtang@163.com> <5fea4cd474d5fe49688f88d91cdf5e8019844806.1445181079.git.geliangtang@163.com> <918fdb002ec3b2a9fc5a5d364c0fbaff2f77c5cc.1445181079.git.geliangtang@163.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s/regsiter/register/

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ccab89f..6dc5faf 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1880,10 +1880,10 @@ static void __exit exit_wilc_driver(void)
 	}
 
 #ifndef WILC_SDIO
-	PRINT_D(INIT_DBG, "SPI unregsiter...\n");
+	PRINT_D(INIT_DBG, "SPI unregister...\n");
 	spi_unregister_driver(&wilc_bus);
 #else
-	PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
+	PRINT_D(INIT_DBG, "SDIO unregister...\n");
 	sdio_unregister_driver(&wilc_bus);
 #endif
 
-- 
2.5.0


