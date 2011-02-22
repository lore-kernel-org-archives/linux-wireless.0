Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51957 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1BVMTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 07:19:30 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p1MCJUSe014440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 06:19:30 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p1MCJUVV023091
	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 06:19:30 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p1MCJU3V016415
	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 06:19:30 -0600 (CST)
Received: from pimenta.emea.dhcp.ti.com (pimenta.emea.dhcp.ti.com
 [137.167.41.164])	by dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id
 p1MCJSge026295	for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011
 06:19:29 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix MODULE_AUTHOR email address
Date: Tue, 22 Feb 2011 14:19:28 +0200
Message-ID: <1298377168-14954-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change my old email address to the new one in MODULE_AUTHOR.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 61dea73..a3e15f5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3412,5 +3412,5 @@ module_param_named(debug_level, wl12xx_debug_level, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-- 
1.7.1

