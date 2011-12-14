Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39631 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289Ab1LNM6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 07:58:13 -0500
Received: by lahj13 with SMTP id j13so364109lah.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 04:58:08 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: remove unused firmware version macros
Date: Wed, 14 Dec 2011 14:57:58 +0200
Message-Id: <1323867478-23238-1-git-send-email-coelho@ti.com> (sfid-20111214_135820_908614_CE54843F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't use WL12XX_BA_SUPPORT_FW_COST_VER2_START nor
WL12XX_BA_SUPPORT_FW_COST_VER2_END anymore.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/wl12xx.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index f1c9117..d21f71f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -35,13 +35,6 @@
 #include "conf.h"
 #include "ini.h"
 
-/*
- * FW versions support BA 11n
- * versions marks x.x.x.50-60.x
- */
-#define WL12XX_BA_SUPPORT_FW_COST_VER2_START    50
-#define WL12XX_BA_SUPPORT_FW_COST_VER2_END      60
-
 #define WL127X_FW_NAME "ti-connectivity/wl127x-fw-3.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"
 
-- 
1.7.4.1

