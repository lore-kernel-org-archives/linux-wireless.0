Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52458 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdG0WBN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 18:01:13 -0400
From: Colin King <colin.king@canonical.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix spelling mistake: "Iinitialization" -> "initialization"
Date: Thu, 27 Jul 2017 23:01:10 +0100
Message-Id: <20170727220110.11655-1-colin.king@canonical.com> (sfid-20170728_000128_030948_6B202FC5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in netdev_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1266dcccad30..119f3459b5bb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -813,7 +813,7 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 		wilc_wlan_cleanup(dev);
 _fail_locks_:
 		wlan_deinit_locks(dev);
-		netdev_err(dev, "WLAN Iinitialization FAILED\n");
+		netdev_err(dev, "WLAN initialization FAILED\n");
 	} else {
 		netdev_dbg(dev, "wilc1000 already initialized\n");
 	}
-- 
2.11.0
