Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:53693 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752379AbdALDpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 22:45:15 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 5/7] staging:wilc1000:wilc_debugfs.c Removes multiple blank lines
Date: Wed, 11 Jan 2017 21:38:36 -0600
Message-Id: <1484192328-16825-5-git-send-email-scott@matheina.com> (sfid-20170112_044527_870710_19569052)
In-Reply-To: <1484192328-16825-1-git-send-email-scott@matheina.com>
References: <1484192328-16825-1-git-send-email-scott@matheina.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch CHECK: Please don't use multiple blank lines

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 52aac75..7d32de9 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -17,7 +17,6 @@
 
 #include "wilc_wlan_if.h"
 
-
 static struct dentry *wilc_dir;
 
 /*
@@ -36,7 +35,6 @@ EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
  * --------------------------------------------------------------------------------
  */
 
-
 static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, size_t count, loff_t *ppos)
 {
 	char buf[128];
-- 
2.7.4
