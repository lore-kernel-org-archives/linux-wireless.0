Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:57881 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3EJHs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 03:48:29 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <tony@atomide.com>
Subject: [PATCH] wl12xx: increase minimum singlerole firmware version required
Date: Fri, 10 May 2013 10:47:04 +0300
Message-ID: <1368172024-14746-1-git-send-email-coelho@ti.com> (sfid-20130510_094843_490981_8E577DA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The minimum firmware version required for singlerole after recent
driver changes is 6/7.3.10.0.133.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 139da4d..9e5484a 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -36,7 +36,7 @@
 #define WL127X_IFTYPE_SR_VER	3
 #define WL127X_MAJOR_SR_VER	10
 #define WL127X_SUBTYPE_SR_VER	WLCORE_FW_VER_IGNORE
-#define WL127X_MINOR_SR_VER	115
+#define WL127X_MINOR_SR_VER	133
 /* minimum multi-role FW version for wl127x */
 #define WL127X_IFTYPE_MR_VER	5
 #define WL127X_MAJOR_MR_VER	7
@@ -49,7 +49,7 @@
 #define WL128X_IFTYPE_SR_VER	3
 #define WL128X_MAJOR_SR_VER	10
 #define WL128X_SUBTYPE_SR_VER	WLCORE_FW_VER_IGNORE
-#define WL128X_MINOR_SR_VER	115
+#define WL128X_MINOR_SR_VER	133
 /* minimum multi-role FW version for wl128x */
 #define WL128X_IFTYPE_MR_VER	5
 #define WL128X_MAJOR_MR_VER	7
-- 
1.7.10.4

