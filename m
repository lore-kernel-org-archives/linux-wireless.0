Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39233 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753141AbeADPIG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 10:08:06 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [linux-next] rt2x00: Fix a typo in printk
Date: Fri,  5 Jan 2018 00:08:00 +0900
Message-Id: <20180104150800.1972-1-standby24x7@gmail.com> (sfid-20180104_160827_332635_931D1FAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix a typo in rt2800lib.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d2c289446c00..429d07b651dd 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4903,7 +4903,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		min_sleep = 2000;
 		break;
 	default:
-		WARN_ONCE(1, "Not supported RF chipet %x for VCO recalibration",
+		WARN_ONCE(1, "Not supported RF chipset %x for VCO recalibration",
 			  rt2x00dev->chip.rf);
 		return;
 	}
-- 
2.15.1.433.g936d1b989416
