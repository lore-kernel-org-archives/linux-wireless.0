Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32826 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdHCWAz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 18:00:55 -0400
From: Himanshu Jha <himanshujha199640@gmail.com>
To: gregkh@linuxfoundation.org
Cc: aditya.shankar@microchip.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] Staging: wilc1000: Fix line over 80 characters
Date: Fri,  4 Aug 2017 03:30:22 +0530
Message-Id: <1501797622-1711-1-git-send-email-himanshujha199640@gmail.com> (sfid-20170804_000112_567135_D3F2F631)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes 80 characters limit coding style issue.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index dbb3e24..5dab2cd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1087,7 +1087,8 @@ static int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 				snprintf(buff, size, "rssi %d", rssi);
 
-				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
+				if (copy_to_user(wrq->u.data.pointer, buff,
+							size)) {
 					netdev_err(ndev, "failed to copy\n");
 					ret = -EFAULT;
 					goto done;
-- 
2.7.4
