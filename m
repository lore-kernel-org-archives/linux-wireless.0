Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from box.matheina.com ([104.236.11.237]:42092 "EHLO box.matheina.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752775AbdALDpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 22:45:15 -0500
From: Scott Matheina <scott@matheina.com>
To: linux-kernel@vger.kernel.org
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/7] staging:wilc1000:linux_wlan.c Align code to match open parenthesis
Date: Wed, 11 Jan 2017 21:38:34 -0600
Message-Id: <1484192328-16825-3-git-send-email-scott@matheina.com> (sfid-20170112_044523_362767_75B97967)
In-Reply-To: <1484192328-16825-1-git-send-email-scott@matheina.com>
References: <1484192328-16825-1-git-send-email-scott@matheina.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch CHECK: Alignment should match open parenthesis

Signed-off-by: Scott Matheina <scott@matheina.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 185fcd1..9ab4393 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -364,7 +364,7 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 		return ret;
 
 	if (!wait_for_completion_timeout(&wilc->sync_event,
-					msecs_to_jiffies(5000)))
+					 msecs_to_jiffies(5000)))
 		return -ETIME;
 
 	return 0;
-- 
2.7.4
