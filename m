Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56900 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1HZGfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:35:10 -0400
Subject: [PATCH] p54spi: add "spi:" prefix for stlc45xx modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 14:34:59 +0800
Message-ID: <1314340499.25655.1.camel@phoenix> (sfid-20110826_083536_710695_48837DEE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit e0626e38 (spi: prefix modalias with "spi:"),
the spi modalias is prefixed with "spi:".

This patch adds "spi:" prefix for modalias of stlc45xx.
Also move it to be group with other modalias.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/net/wireless/p54/p54spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 6d9204fe..f18df82 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -41,7 +41,6 @@
 #endif /* CONFIG_P54_SPI_DEFAULT_EEPROM */
 
 MODULE_FIRMWARE("3826.arm");
-MODULE_ALIAS("stlc45xx");
 
 /*
  * gpios should be handled in board files and provided via platform data,
@@ -738,3 +737,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
 MODULE_ALIAS("spi:cx3110x");
 MODULE_ALIAS("spi:p54spi");
+MODULE_ALIAS("spi:stlc45xx");
-- 
1.7.4.1



