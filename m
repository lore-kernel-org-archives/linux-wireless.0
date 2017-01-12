Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:54610 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752773AbdALDpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 22:45:15 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 4/7] staging:wilc1000:wilc_debugfs.c Aligns code to match open parenthesis
Date: Wed, 11 Jan 2017 21:38:35 -0600
Message-Id: <1484192328-16825-4-git-send-email-scott@matheina.com> (sfid-20170112_044533_004194_09728D23)
In-Reply-To: <1484192328-16825-1-git-send-email-scott@matheina.com>
References: <1484192328-16825-1-git-send-email-scott@matheina.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch CHECK: Alignment should match open parenthesis

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 07260c4..52aac75 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -52,7 +52,7 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, si
 }
 
 static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
-					size_t count, loff_t *ppos)
+				      size_t count, loff_t *ppos)
 {
 	int flag = 0;
 	int ret;
-- 
2.7.4
