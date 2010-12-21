Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50615 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab0LUBCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:09 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Kalle Valo <kvalo@adurom.com>
Subject: [PATCH 1/7] wl1251: remove unnecessary import
Date: Tue, 21 Dec 2010 02:01:50 +0100
Message-Id: <1292893316-26694-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No function declared in gpio.h is used here.

CC: Kalle Valo <kvalo@adurom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/wl1251/boot.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/boot.c b/drivers/net/wireless/wl1251/boot.c
index 61572df..d729daf 100644
--- a/drivers/net/wireless/wl1251/boot.c
+++ b/drivers/net/wireless/wl1251/boot.c
@@ -19,7 +19,6 @@
  *
  */
 
-#include <linux/gpio.h>
 #include <linux/slab.h>
 
 #include "reg.h"
-- 
1.7.1

